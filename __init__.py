import bibtexparser
import sys

import re
import string

from bibtexparser.bparser import BibTexParser
from bibtexparser.customization import convert_to_unicode

from GraphDatabase import GraphDatabase

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

print "Loading file... ",

with open('complex-network.bib') as bibtex_file:

   graphDatabase = GraphDatabase(password = "password")

   parser = BibTexParser()

   parser.customization = convert_to_unicode

   bib_database = bibtexparser.load(bibtex_file, parser = parser)

   i = 0

   print "[OK]"
   
   for entry in bib_database.entries:

      if 'author' not in entry or 'abstract' not in entry or 'year' not in entry: continue

      i += 1

      print "[" + `i` + "] " + entry["title"] 

      entry["title"] = entry["title"].strip().lower().replace("\\", "").encode(sys.stdout.encoding, errors='replace')
      
      entry["year"]  = entry["year"].strip().lower().replace("\\", "").encode(sys.stdout.encoding, errors='replace')
      
      graphDatabase.query("MERGE (p:Paper {title: \"" + entry["title"] + "\", year: " + entry["year"] + "});")
      
      for author in entry["author"].split(" and"):

         author = author.strip().lower().encode(sys.stdout.encoding, errors='replace').replace("\\", "")

         graphDatabase.query("MERGE (n:Author {name: \"" +  author + "\"});")
            
         graphDatabase.query("MATCH (n:Author {name: \"" +  author + "\"}), (p:Paper {title: \"" + entry["title"] + "\"}) " + 
                             "CREATE UNIQUE (n)-[:WRITE]-(p);")

      reg = "[ ?\\.!/;:,\\(\\)\\[\\]\\{\\}*&%\\$#@\\^~`=\\+_\'\"]".encode(sys.stdout.encoding, errors = 'replace')
      
      words = [re.sub(reg, '', x.strip().lower()) 
               for x in entry["abstract"].split(" ") 
               if re.sub(reg, '', x.strip().lower().strip()) 
                  not in blacklist and not x.strip().isdigit()]
               
      for word in words:
         
         word = word.replace("\\", "").replace(".", "").encode(sys.stdout.encoding, errors='replace')
         
         graphDatabase.query("MERGE (w:Word {value: \"" + word + "\"});")
         
         graphDatabase.query("MATCH (w:Word {value: \"" +  word + "\"}), (p:Paper {title: \"" + entry["title"] + "\"}) " + 
                             "CREATE UNIQUE (p)-[:CONTAINS]-(w);")
   
   print "Finished. We import " + `i` + " papers"