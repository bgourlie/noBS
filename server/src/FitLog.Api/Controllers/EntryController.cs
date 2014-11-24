using Microsoft.AspNet.Mvc;
using System;

namespace FitLog.Api.Controllers
{
    [Route("api/[controller]")]
    public class EntryController
    {

    [HttpGet]
    public IActionResult Get()
        {
            return new ObjectResult("hello!");
        }
    }
}