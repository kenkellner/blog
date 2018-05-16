#!/usr/bin/python3

from feedgen.feed import FeedGenerator
import os
import re
import operator
from datetime import datetime

leader='https://kenkellner.com/blog/' 

links = os.listdir('build')
links.remove('index.html')
if 'feed.xml' in links:
    links.remove('feed.xml')

src = []
for i in links:
    src.append('src/'+i.replace('.html','.Rmd'))

dates = []
for i in src:
    for line in open(i):
        if 'date: ' in line:
            dates.append(line.split(': ')[1].strip('\n'))
            break

titles = []
for i in src: 
    for line in open(i):
        if 'title: ' in line:
            title_raw = line.split(': ',1)[1].strip('\n')
            title_raw = re.sub(r"^'","",title_raw)
            title_raw = re.sub(r"'$","",title_raw)
            titles.append(title_raw)
            break

dates, links, titles = zip(*sorted(zip(dates, links, titles)))

fg = FeedGenerator()
fg.id(leader)
fg.link(href=leader+'feed.xml', rel='self')
fg.title('Ken Kellner\'s Blog')
fg.subtitle(' ')
fg.language('en')

for i in range(len(dates)):
    fe = fg.add_entry()
    fe.title(titles[i])
    fe.id(leader+links[i])
    fe.link(href=leader+links[i])
    fe.author({'name': 'Ken Kellner', 'email': 'contact@kenkellner.com'})
    fe.description('')
    date_raw = dates[i]+' -0500'
    fe.published(datetime.strptime(date_raw, '%Y-%m-%d %z'))

fg.rss_str(pretty=True)
fg.rss_file('build/feed.xml')
