#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import os
import jinja2
from google.appengine.ext import ndb
import webapp2

jinja_env = jinja2.Environment(loader=jinja2.FileSystemLoader(os.path.dirname(__file__)), autoescape=True)

EPACAR_PARENT_KEY = ndb.Key("Entity", 'epacar_root')


class MainHandler(webapp2.RequestHandler):
    def get(self):
        self.response.write('Welcome to Gas Stats!')
        
    def post(self):
        new_epacar = EPACar(parent=EPACAR_PARENT_KEY,
                      make=self.request.get('make'),
                      model=self.request.get('model'),
                      year=self.request.get('year'),
                      city_mpg=self.request.get('city_mpg'),
                      high_mpg=self.request.get('high_mpg'),
                      comb_mpg=self.request.get('comb_mpg'))
        new_epacar.put()
        self.redirect(self.request.referer)    

app = webapp2.WSGIApplication([('/', MainHandler)], debug=True)
