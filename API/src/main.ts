import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import helmet from 'helmet';
import { ValidationPipe } from '@nestjs/common';
import { setupSwagger } from './app.swagger';


async function bootstrap() {
const app = await NestFactory.create(AppModule, { cors: true });
app.use(helmet());
app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
setupSwagger(app);
const port = process.env.PORT || 3000;
await app.listen(port);
console.log(`EFD API running on http://localhost:${port}`);
}
bootstrap();