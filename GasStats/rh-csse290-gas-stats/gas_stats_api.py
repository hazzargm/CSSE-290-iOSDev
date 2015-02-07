import endpoints
import main
import car
import epa
import gasstat
import driver
import protorpc

from models import Car
from models import EpaCar
from models import GasStat
from models import Driver

@endpoints.api(name="gasstats", version="v1", description="GasStats API")
class GasStatsApi(protorpc.remote.Service):
    pass

    """Car methods and queries"""
    @Car.method(path="car/insert", name="car.insert", http_method="POST")
    def car_insert(self, request):
        if request.from_datastore:
            my_car = request
        else:
            my_car = Car(parent=car.CAR_PARENT_KEY,
                         car_id=request.car_id,
                         icon=request.icon,
                         make=request.make,
                         model=request.model,
                         shared=request.shared,
                         year=request.year)
        my_car.put()
        return my_car
    
    @Car.query_method(path="car/list", http_method="GET",
                             name="car.list", query_fields=("limit", "order", "pageToken"))
    def car_list(self, query):
        return query
    
    @Car.method(request_fields=("entityKey",), path="car/delete/{entityKey}",
                       http_method="DELETE", name="car.delete")
    def car_delete(self, request):
        if not request.from_datastore:
            raise endpoints.NotFoundException("car not found")
        request.key.delete()
        return Car(make="deleted")
    
    """EPACar methods and queries"""
    @EpaCar.method(path="epacar/insert", name="epacar.insert", http_method="POST")
    def epacar_insert(self, request):
        if request.from_datastore:
            my_epacar = request
        else:
            my_epacar = EpaCar(parent=epa.EPACAR_PARENT_KEY,
                               year=request.year,
                               make=request.make,
                               model=request.model,
                               city_mpg=request.city_mpg,
                               high_mpg=request.high_mpg,
                               comb_mpg=request.comb_mpg)
        my_epacar.put()
        return my_epacar
    
    @EpaCar.query_method(path="epacar/list", http_method="GET",
                         name="epacar.list", query_fields=("limit", "order", "pageToken"))
    def epacar_list(self, query):
        return query
    
    @EpaCar.query_method(path="epacar/list/by/year", http_method="GET",
                         name="epacar.list.by.year", query_fields=("year",))
    def epacar_list_by_year(self, query):
        return query
    
    @EpaCar.query_method(path="epacar/list/by/year/make", http_method="GET",
                         name="epacar.list.by.year.make", query_fields=("year","make"))
    def epacar_list_by_year_make(self, query):
        return query
    
    @EpaCar.method(request_fields=("entityKey",), path="epacar/delete/{entityKey}",
                       http_method="DELETE", name="epacar.delete")
    def epacar_delete(self, request):
        if not request.from_datastore:
            raise endpoints.NotFoundException("epacar not found")
        request.key.delete()
        return EpaCar(make="deleted")

    """GasStat methods and queries"""
    @GasStat.method(path="gasstat/insert", name="gasstat.insert", http_method="POST")
    def gasstat_insert(self, request):
        if request.from_datastore:
            my_gasstat = request
        else:
            my_gasstat = GasStat(parent=gasstat.GAS_STAT_PARENT_KEY,
                                 car_id=request.car_id,
                                 cost=request.cost,
                                 gallons=request.gallons,
                                 miles=request.miles,
                                 mpg=request.mpg,
                                 user_id=request.user_id)
        my_gasstat.put()
        return my_gasstat

    @GasStat.query_method(path="gasstat/list", http_method="GET",
                         name="gasstat.list", query_fields=("limit", "order", "pageToken"))
    def gasstat_list(self, query):
        return query
    
    @GasStat.method(request_fields=("entityKey",), path="gasstat/delete/{entityKey}",
                       http_method="DELETE", name="gasstat.delete")
    def gasstat_delete(self, request):
        if not request.from_datastore:
            raise endpoints.NotFoundException("gassstat not found")
        request.key.delete()
        return GasStat(cost=0)
    
    """Driver methods and queries"""
    @Driver.method(path="driver/insert", name="driver.insert", http_method="POST")
    def driver_insert(self, request):
        if request.from_datastore:
            my_driver = request
        else:
            my_driver = Driver(parent=driver.DRIVER_PARENT_KEY,
                                 email=request.email,
                                 password=request.password,
                                 user_id=request.user_id,
                                 username=request.username)
        my_driver.put()
        return my_driver

    @Driver.query_method(path="driver/list", http_method="GET",
                         name="driver.list", query_fields=("limit", "order", "pageToken"))
    def driver_list(self, query):
        return query
    
    @Driver.method(request_fields=("entityKey",), path="driver/delete/{entityKey}",
                       http_method="DELETE", name="driver.delete")
    def driver_delete(self, request):
        if not request.from_datastore:
            raise endpoints.NotFoundException("driver not found")
        request.key.delete()
        return Driver(username="deleted")
    
app = endpoints.api_server([GasStatsApi], restricted=False)