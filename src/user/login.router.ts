/**
 * Required External Modules and Interfaces
 */

import jwt from 'jsonwebtoken'
import express, { Request, Response } from "express";
import { ClientRealtor, ClientUser, PrismaClient, User, UserRole } from '@prisma/client';

/**
 * Router Definition
 */

export const loginRouter = express.Router();

/**
 * Controller Definitions
 */

// GET items

const client = new PrismaClient()

loginRouter.post("/login", async (req: Request, res: Response) => {
  try {
    const { name } = req.body
    
    // const clientsWhereThisUserIsRealtor = await client.clientRealtor.findMany({
    //   where: {
    //     userId
    //   }
    // })

    const user = await client.user.findFirstOrThrow({
      where: {
        name
      },
      select: {
        id: true,
        ClientRealtor: {
          select: {
            id: true,
            clientId: true
          }
        }
      }
    }) 
    console.log(user)
    const clientsWhereThisUserIsRealtor = user.ClientRealtor.map(realtor => {
      return { clientId: realtor.clientId }
    })

    const clientsWhereThisUserIsNotRealtor = await client.clientUser.findMany({
      where: {
        userId: user.id,
        NOT: clientsWhereThisUserIsRealtor
      },
      select: {
        clientId: true
      }
    })

    user.ClientUser = clientsWhereThisUserIsNotRealtor
    
    const token = await jwt.sign({user}, "secret", {subject: String(user.id), expiresIn: '1d'})

    return res.status(200).send({token, user});
  } catch (e) {
    return res.status(500).send(e.message);
  }
});

loginRouter.get("/teste", async (req: Request, res: Response) => {
  try {
    const token = getTokenFromRequest(req)
    
    const payload = jwt.verify(token, 'secret')
    console.log(JSON.stringify(payload))
    return res.status(200).send(payload);
  } catch (e) {
    return res.status(500).send(e.message);
  }
});

loginRouter.get("/enterprises", async (req: Request, res: Response) => {
  try {
    const token = getTokenFromRequest(req)
    
    const payload = jwt.verify(token, 'secret') as {
      user: User & {
        UserRole: UserRole[];
        ClientUser: ClientUser[];
        ClientRealtor: ClientRealtor[];
      }
    }

    console.log(payload.user.ClientUser)
    const realtorIds = payload.user.ClientRealtor.map(cr => {
      return { clientRealtorId: cr.id }
    })
    const clientIds = payload.user.ClientUser.map(cu => {
      return { clientEnterprise: { clientId: cu.clientId } }
    })
    // payload.user.ClientUser.map(cu => {
    //   return { clientId: cu.clientId }
    // })

    console.log(realtorIds)
    const enterprises = await client.clientEnterpriseRealtors.findMany({
      where: {
        OR: realtorIds,
      },
      select: {
        clientEnterprise: {
          select: {
            id: true,
            name: true
          }
        }
      }
    })

    return res.status(200).send(enterprises);
  } catch (e) {
    return res.status(500).send(e.message);
  }
});


function getTokenFromRequest(req: Request){
  const bearerToken = req.headers['authorization']
  const parts = bearerToken?.split(' ')
  const token = parts[1]
  return token
}