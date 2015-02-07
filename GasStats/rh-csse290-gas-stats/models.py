from endpoints_proto_datastore.ndb.model import EndpointsModel
from google.appengine.ext import ndb

class Car(EndpointsModel):
    _message_fields_schema = ("entityKey", "create_date_time", "car_id", "icon", "make", "model", "shared", "year")
    create_date_time = ndb.DateTimeProperty(auto_now=True)
    car_id = ndb.IntegerProperty()
    icon = ndb.BlobProperty()
    make = ndb.StringProperty()
    model = ndb.StringProperty()
    shared = ndb.BooleanProperty()
    year = ndb.IntegerProperty()
    
class EPACar(EndpointsModel):
    _message_fields_scheme = ("entityKey", "year", "make", "model", "city_mpg", "high_mpg", "comb_mpg")
    year = ndb.IntegerProperty()
    make = ndb.StringProperty()
    model = ndb.StringProperty()
    city_mpg = ndb.FloatProperty()
    high_mpg = ndb.FloatProperty()
    comb_mpg = ndb.FloatProperty()