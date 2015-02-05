import endpoints
import main
import protorpc

from models import Car

@endpoints.api(name="gasstats", version="v1", description="GasStats API")
class GasStatsApi(protorpc.remote.Service):
    pass
"""
    @Car.method(path="car/insert", name="car.insert", http_method="POST")
    def car_insert(self, request):
        if request.from_datastore:
            my_car = request
        else:
            my_car = Car(parent=main.PARENT_KEY,
                         car_id=request.car_id,
                         icon=request.icon,
                         make=request.make,
                         model=request.model,
                         shared=request.shared,
                         year=request.year)
        my_car.put()
        return my_car
"""
app = endpoints.api_server([GasStatsApi], restricted=False)

"""
from models import Weatherpic

@endpoints.api(name="weatherpics", version="v1", description="Weatherpics API")
class WeatherpicsApi(protorpc.remote.Service):
    pass

    @Weatherpic.method(path="weatherpic/insert", name="weatherpic.insert", http_method="POST")
    def weatherpic_insert(self, request):
        if request.from_datastore:
            my_weatherpic = request
        else:
            my_weatherpic = Weatherpic(parent=main.PARENT_KEY, image_url=request.image_url, caption=request.caption)
        my_weatherpic.put()
        return my_weatherpic
    
    @Weatherpic.query_method(path="weatherpic/list", http_method="GET",
                             name="weatherpic.list", query_fields=("limit", "order", "pageToken"))
    def weatherpic_list(self, query):
        return query
    
    @Weatherpic.method(request_fields=("entityKey",), path="weatherpic/delete/{entityKey}",
                       http_method="DELETE", name="weatherpic.delete")
    def weatherpic_delete(self, request):
        if not request.from_datastore:
            raise endpoints.NotFoundException("weatherpic not found")
        request.key.delete()
        return Weatherpic(caption="deleted")

app = endpoints.api_server([WeatherpicsApi], restricted=False)
"""