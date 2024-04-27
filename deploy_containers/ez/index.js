const esi = require('./esi_server/index');
const api = require('./weather_api/index');
const flag = require('./flag_server/index');

//flag.PORT = 8080

flag.app.listen(flag.PORT, () => {
	console.log(`Flag server listening on ${flag.PORT}`);
});


api.app.listen(api.PORT, () => {
	console.log(`Api server listening on ${api.PORT}`);
});

esi.app.listen(esi.PORT, () => {
	console.log(`Esi server listening on ${esi.PORT}`);
});
