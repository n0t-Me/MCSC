using GraphQL_test;
using HotChocolate.AspNetCore;

var builder = WebApplication.CreateBuilder();

builder.Services.AddCors();

builder.Services
    .AddGraphQLServer()
    .AddQueryType<Query>();

var app = builder.Build();

app.UseCors(builder =>
{
    builder.AllowAnyHeader()
           .AllowAnyMethod()
           .AllowAnyOrigin();
});


app.MapGraphQL().WithOptions(new GraphQLServerOptions
{
    Tool =
    {
        Enable = app.Environment.IsDevelopment()
    }

});

app.Run();
