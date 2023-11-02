using DoAn_WebDocSach.Models;
using Autofac;
using DoAn_WebDocSach.Dao;

public class DataAccessModule : Module
{
    protected override void Load(ContainerBuilder builder)
    {
        builder.RegisterType<WEBDOCSACHEntities>().AsSelf().InstancePerLifetimeScope();
        builder.RegisterType<UserDao>().As<UserDao>().InstancePerLifetimeScope();
    }
}