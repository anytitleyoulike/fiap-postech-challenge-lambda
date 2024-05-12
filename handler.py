import json
import boto3 

client = boto3.client('cognito-idp', 'us-east-1')
def lambda_handler(event, context):
    username = event['email']
    password = event['password']
    try: 
        response = client.initiate_auth(
                ClientId='73itbfu7mhqv4240crepo41u92',
                AuthFlow='USER_PASSWORD_AUTH',
                AuthParameters={
                    'USERNAME': username,
                    'PASSWORD': password
                }
            )
        
        return {
            'status': 200,
            'body': {
                'message': 'Login successful!',
                'session': response['Session']
            }
        }
    except client.exceptions.NotAuthorizedException:
        return {'Error': 'Invalid username or password'}
    except Exception as e:
        return e
    