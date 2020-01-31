# Domain Driven Design

### Domains

One way of thinking about domain design is that domains should essentially be treatable as external vendor modules -- entirely self-supporting, with a clear API. This can be described as a microservice approach, or separately bounded contexts.

### Domain events

A pattern that decouples chains of actions. E.g., instead of a user signup controller creating the user, creating a referral code, and sending an email, it would simply create a user and publish a "user created" event. Then, some referrals service that has subscribed to this event would respond by creating a referral code, and same for email.

This has parallels to handling chains of events in React via prop changes, rather than having a chain of tail calls, or simply having a bunch of calls to other methods within methods. Whereas the first approach is the only option for cross-component communication, it can also benefit intra-component communication by decoupling methods within a single class.

#### Downsides
- Difficulty of comprehension and tracing errors. Once message passing occurs, stack traces lose usability.
- Lots of up front design work, and the up front work has to be done well, else everything built on the foundational domain will be faulty. This is extra difficult because abstractions have to be correctly identified and well understood.

## MVC vs. DDD

- Models responsibility is broken up
  - **Repositories** handle storage (DB etc.) interaction (get / modify). In Rails this is usually handled by ActiveRecord.
  - **Entities** handle validation, creation, and a limited range of setters. Entities have identity.
  - **Mappers** handle transformation from DB representations to entities and vice versa. In Rails this is generally done automagically.

## Resources

- [Domain Driven Design Intro](https://khalilstemmler.com/articles/domain-driven-design-intro/)
