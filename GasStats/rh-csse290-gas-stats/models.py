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
    
class EpaCar(EndpointsModel):
    _message_fields_schema = ("entityKey", "year", "make", "model", "city_mpg", "high_mpg", "comb_mpg")
    year = ndb.IntegerProperty()
    make = ndb.StringProperty()
    model = ndb.StringProperty()
    city_mpg = ndb.FloatProperty()
    high_mpg = ndb.FloatProperty()
    comb_mpg = ndb.FloatProperty()
    
class GasStat(EndpointsModel):
    _message_fields_schema = ("entityKey", "car_id", "cost", "create_date_time", "gallons", "miles", "mpg", "user_id")
    car_id = ndb.IntegerProperty()
    cost = ndb.FloatProperty()
    create_date_time = ndb.DateTimeProperty(auto_now=True)
    gallons = ndb.FloatProperty()
    miles = ndb.FloatProperty()
    mpg = ndb.FloatProperty()
    user_id = ndb.IntegerProperty()
    
class Driver(EndpointsModel):
    _message_fields_schema = ("entityKey", "email", "create_date_time", "password", "user_id", "username")
    email = ndb.StringProperty()
    create_date_time = ndb.DateTimeProperty(auto_now=True)
    password= ndb.StringProperty()
    user_id = ndb.IntegerProperty()
    username = ndb.StringProperty()