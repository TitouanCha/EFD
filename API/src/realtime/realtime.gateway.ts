import { WebSocketGateway, WebSocketServer, SubscribeMessage, MessageBody } from '@nestjs/websockets';
import { Server } from 'ws';


@WebSocketGateway({ path: '/ws' })
export class RealtimeGateway {
@WebSocketServer() server: Server;


// Broadcast position estimates (admin map). Clients (couriers app) can push updates.
@SubscribeMessage('courier:update')
handleCourierUpdate(@MessageBody() data: { courierId: string; lat: number; lng: number; ts?: string }) {
this.server.clients.forEach((client: any) => {
client.send(JSON.stringify({ type: 'courier:update', data }));
});
}
}