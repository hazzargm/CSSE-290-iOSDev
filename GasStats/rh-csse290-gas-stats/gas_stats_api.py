import endpoints
import main
import epa
import protorpc

from models import Car
from models import EPACar

@endpoints.api(name="gasstats", version="v1", description="GasStats API")
class GasStatsApi(protorpc.remote.Service):
    pass

    """Car methods and queries"""
    @Car.method(path="car/insert", name="car.insert", http_method="POST")
    def car_insert(self, request):
        if request.from_datastore:
            my_car = request
        else:
            my_car = Car(parent=main.CAR_PARENT_KEY,
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
    @EPACar.method(path="epacar/insert", name="epacar.insert", http_method="POST")
    def epa_car(self, request):
        if request.from_datastore:
            my_epacar = request
        else:
            my_epacar = EPACar(parent=epa.EPACAR_PARENT_KEY,
                               year=request.year,
                               make=request.make,
                               model=request.model,
                               city_mpg=request.city_mpg,
                               high_mpg=request.high_mpg,
                               comb_mpg=request.comb_mpg)
        my_epacar.put()
        return my_epacar
    
    @EPACar.query_method(path="epacar/list", http_method="GET",
                         name="epacar.list", query_fields=("limit", "order", "pageToken"))
    def epacar_list(self, query):
        return query
    
    @EPACar.method(request_fields=("entityKey",), path="epacar/delete/{entityKey}",
                       http_method="DELETE", name="epacar.delete")
    def epacar_delete(self, request):
        if not request.from_datastore:
            raise endpoints.NotFoundException("epacar not found")
        request.key.delete()
        return EPACar(make="deleted")

app = endpoints.api_server([GasStatsApi], restricted=False)