import bibtexparser
import sys

import re
import string

from bibtexparser.bparser import BibTexParser
from bibtexparser.customization import convert_to_unicode

from GraphDatabase import GraphDatabase

#
# List of words to be excluded from the graph .
blacklist = [
"a", "an", "and", "nor", "or", "yet", "so", "as", "at", "and", "of", "the", "is", "can", "results", "moreover", "shown", "both", "ii", 
"on", "or", "in", "to", "by", "aboard", "about", "above", "across", "after", "against", "along", "which", "proposed", "furthermore", "either", "iii",
"amid", "among", "anti", "around", "as", "at", "before", "behind", "below", "beneath", "beside", "makes", "more", "their", "any", "therefore", "iv",
"besides", "between", "beyond", "but", "by", "concerning", "considering", "despite", "down", "during", "also", "used", "such", "presented", "vi", 
"except", "excepting", "excluding", "following", "for", "from", "in", "inside", "into", "like", "occurs", "each", "most", "then", "could", "vii",
"minus", "near", "of", "off", "on", "onto", "opposite", "outside", "over", "past", "per", "does", "well", "first", "present", "only", "viii", "ones",
"plus", "regarding", "round", "save", "since", "than", "through", "to", "toward", "towards", "occur", "make", "many", "further", "need", "ie", "other"
"under", "underneath", "unlike", "until", "up", "upon", "versus", "via", "with", "within", "paper", "again", "may", "due", "finally", "ix", "xi", "new",
"without", "abstract", "aim", "aiming", "once", "because", "since", "why", "how", "if", "whether", "some", "them", "very", "second", "thus", "xii",
"where", "wherever", "whereas", "than", "much", "though", "until", "when", "while", "be", "was", "were", "that", "addition", "some", "had", "xiii",
"out", "in", "are", "is", "we", "they", "he", "it", "has", "have", "please", "she", "him", "her", "who", "all", "given", "previous", "out", "xiv", " "
"whom", "this", "these", "there", "those", "been", "done", "did", "do", "its", "however", "one", "two", "our", "often", "main", "same", "vs", "must",
"three", "four", "five" "six", "seven", "nine", "ten", "eleven", "hundred", "not", "no", "yes", "maybe", "based", "using", "show", "such", "use"
] + list(string.ascii_lowercase)
#
# Regular expression to exclude characters from words, titles, and author names
reg = "[\\?\\.!/;:,\\(\\)\\[\\]\\{\\}\\*&%\\$#@\\^~`=\\+_\'\"\\\\]".encode(sys.stdout.encoding, errors = 'replace')
#
#
print "Loading file... ",
#
# Loading bibtex file
bibtex_file = open('dataset/complex-network-2000.bib')
#
# Connecting to the neo4j
graphDatabase = GraphDatabase(password = "password")
#
# Parsing the bibtex
parser = BibTexParser()
parser.customization = convert_to_unicode
bib_database = bibtexparser.load(bibtex_file, parser = parser)
#
# Counting the number of included papers
numberOfIncludedPapers = 0
#
#
print "Done with " + `len(bib_database.entries)` + " papers."
#
# For each bibliography do
for entry in bib_database.entries:
   #
   #
   try:
      #
      # If bibliography have no any of author, abstract or year attribute exclude it
      if 'author' not in entry or 'abstract' not in entry or 'year' not in entry: continue
      #
      # Starting database transaction 
      graphDatabase.startTransaction()
      #
      # If the bibliography have all required attribute count it
      numberOfIncludedPapers += 1
      #
      # Writing the paper title to visualize the process
      print "[" + `numberOfIncludedPapers` + "] " + entry["title"] 
      #
      # Pre-processing and converting encoding of the title content
      entry["title"] = entry["title"].strip().lower().encode(sys.stdout.encoding, errors='replace')
      #
      # Applying regular expression filter
      entry["title"] = re.sub(reg, '', entry["title"])
      #
      # Converting and pre-processing year content
      entry["year"]  = entry["year"].strip().lower().encode(sys.stdout.encoding, errors='replace')
      #
      # Persisting title as a node
      graphDatabase.query("MERGE (p:Paper {title: \"" + entry["title"] + "\", year: " + entry["year"] + "});")
      #
      # For each author of the paper do
      for author in entry["author"].split(" and"):
         #
         # Converting encoding
         author = author.strip().lower().encode(sys.stdout.encoding, errors='replace').replace("\\", "")
         #
         # Persisting author as a node
         graphDatabase.query("MERGE (n:Author {name: \"" +  author + "\"});")
         #
         # Creating a relationship between paper and author 
         graphDatabase.query("MATCH (n:Author {name: \"" +  author + "\"}), (p:Paper {title: \"" + entry["title"] + "\"}) " + 
                             "CREATE UNIQUE (n)-[:WRITE]-(p);")
   
      #
      # Removing some characters from words
      words = [re.sub(reg, '', x.strip().lower()) 
               for x in entry["abstract"].split(" ") 
               if re.sub(reg, '', x.strip().lower().strip()) 
                  not in blacklist and not x.strip().isdigit()]
               
      #
      # For each word do
      for word in words:
         #
         # Pre-processing and converting encoding of the word
         word = word.replace(" ", "").encode(sys.stdout.encoding, errors='replace')
         #
         # If word is empty continue
         if word == "": continue
         #
         # Persisting the word as a node
         graphDatabase.query("MERGE (w:Word {value: \"" + word + "\"});")
         #
         # Creating a relationship between word and paper
         graphDatabase.query("MATCH (w:Word {value: \"" +  word + "\"}), (p:Paper {title: \"" + entry["title"] + "\"}) " + 
                             "CREATE UNIQUE (p)-[:CONTAINS]-(w);")
   
      #
      # Commiting transaction
      graphDatabase.commit()
   #
   #
   except Exception as exp:
      #
      # Rollbacking transaction
      graphDatabase.rollback()
      #
      # Printing error type and message
      print ">>> " + repr(exp)
      #
      # Discounting included paper
      numberOfIncludedPapers -= 1
      #
      # Please, keep going
      continue
#
# Good bye
print "Finished. It was imported " + `numberOfIncludedPapers` + " papers"