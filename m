Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26E4C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jan 2022 13:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiAQN2D (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jan 2022 08:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232798AbiAQN17 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 17 Jan 2022 08:27:59 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29A3C061574
        for <linux-sgx@vger.kernel.org>; Mon, 17 Jan 2022 05:27:59 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id d11so6434510qkj.12
        for <linux-sgx@vger.kernel.org>; Mon, 17 Jan 2022 05:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hFDF2tPlUbmWEoHNMAw7TG0D6N8Bl0AMVvp/eJFnoik=;
        b=gQIzMHow1dS4cWcNkbuQ6IzKT1CAF/5/5eUqf0SBjqW8kr5umH+z9iqX9lZDi7v/y/
         9fSnZvALgBvMQn7dbs4Xu55q6X/FnU4RtphAggIJAm87XRGXWN4KxdJFC0ubK/GAg1Ng
         OhpVyw81L3YMJNNkM65j7/tnpfCvW7JVKqfQSCkrjFCjEIwzUyQUVG+Ljp5wWVAMUvWc
         b2LArG9QfbOPLhl1gUhCf1hy7n6eCDD6d31lXlMI7HtvP8oSJUeE7/A0BAOMBuR3kjwO
         xZvAnjtGpdllwoQrTkCaTPKjl60Sgq8tMcEIAAgOC6cNoW8kMMG8GrWFOqWz0L8F5xlc
         kUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hFDF2tPlUbmWEoHNMAw7TG0D6N8Bl0AMVvp/eJFnoik=;
        b=YHELT15nR1sJNda4RgiwMIm2ueeueu5IXzLoIL6us6UIHOZHvGpCJohiHcjInUngWB
         N2IszzkHbsZqh7sDm7k26jHHQ2Xo7zqce+erPZgwWy8J+ZaBys6L8a+hkbPCzb88MvVQ
         2Mm4S3mCiVcUyT9EGk/Ku5P+zgi8vDnbzs8rWnBqh4ZFA9UU2JjP8GfDAn+zE0yUjlXH
         Lm91zsr1fSYG+aOEpy0FJt+NJpT68gcgCWouq2Y5OPqFj1VZkQ4MzewYQhMO+byoWv1f
         sOqf3Y0jdBxzwt7JQzTaMq9e0CHmB9UUyKMkwLNqYTkM9V7aAu7wDE2WvXhnuxSBw1/K
         pGkA==
X-Gm-Message-State: AOAM531/opk8Wg2rsCakWkqghNVFCBjd9zEbqnEW6lxVWNonL6izp8rg
        /yiJaYY3y2t5/xoEKtdNbAYU1DREjUNQEQNMwuuu5Q==
X-Google-Smtp-Source: ABdhPJy6OXvTexwF88bxt0G0bRgiqtTH5BtdCVwYVEih7fPZ5WANJC6MX3HYCGgF02fFxrhRZWLc3zJB6cAZUyUGvnM=
X-Received: by 2002:a05:620a:2a0a:: with SMTP id o10mr13774791qkp.47.1642426078828;
 Mon, 17 Jan 2022 05:27:58 -0800 (PST)
MIME-Version: 1.0
References: <573e0836-6ac2-30a4-0c21-d4763707ac96@intel.com>
 <YdgvFTIRboHwTgRT@iki.fi> <op.1fmvdehpwjvjmi@hhuan26-mobl1.mshome.net>
 <YdmxpTVM1JG8nxQ3@iki.fi> <YdmzDy1BOHgh8CII@iki.fi> <Ydm6RiIwuh3IspRI@iki.fi>
 <op.1fsvkfiwwjvjmi@hhuan26-mobl1.mshome.net> <YdzjEzjF0YKn+pZ6@iki.fi>
 <4195402f-cbf9-bc75-719d-22cea8e36e60@intel.com> <Yd9pMq4lUy56B+50@iki.fi>
 <Yd9qmMx7NO450mzZ@iki.fi> <CAHAy0tRi2q+wG+yBttq0FYeK-5wUAoK_=ZCtWsfQf0m8oPc1-w@mail.gmail.com>
 <168fb2c9-de3f-384a-bb17-ab84db2cf533@intel.com>
In-Reply-To: <168fb2c9-de3f-384a-bb17-ab84db2cf533@intel.com>
From:   Nathaniel McCallum <nathaniel@profian.com>
Date:   Mon, 17 Jan 2022 08:27:47 -0500
Message-ID: <CAHAy0tSohetXa5+-_Qhcn_UO8ZvUew+kR_CLZOUePAiUDHO5=Q@mail.gmail.com>
Subject: Re: [PATCH 05/25] x86/sgx: Introduce runtime protection bits
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, dave.hansen@linux.intel.com,
        tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        kai.huang@intel.com, cathy.zhang@intel.com, cedric.xing@intel.com,
        haitao.huang@intel.com, mark.shanahan@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 13, 2022 at 4:43 PM Reinette Chatre
<reinette.chatre@intel.com> wrote:
>
> Hi Jarkko and Nathaniel,
>
> On 1/13/2022 12:09 PM, Nathaniel McCallum wrote:
> > On Wed, Jan 12, 2022 at 6:56 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >>
> >> On Thu, Jan 13, 2022 at 01:50:13AM +0200, Jarkko Sakkinen wrote:
> >>> On Tue, Jan 11, 2022 at 09:13:27AM -0800, Reinette Chatre wrote:
> >>>> Hi Jarkko,
> >>>>
> >>>> On 1/10/2022 5:53 PM, Jarkko Sakkinen wrote:
> >>>>> On Mon, Jan 10, 2022 at 04:05:21PM -0600, Haitao Huang wrote:
> >>>>>> On Sat, 08 Jan 2022 10:22:30 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> >>>>>> wrote:
> >>>>>>
> >>>>>>> On Sat, Jan 08, 2022 at 05:51:46PM +0200, Jarkko Sakkinen wrote:
> >>>>>>>> On Sat, Jan 08, 2022 at 05:45:44PM +0200, Jarkko Sakkinen wrote:
> >>>>>>>>> On Fri, Jan 07, 2022 at 10:14:29AM -0600, Haitao Huang wrote:
> >>>>>>>>>>>>> OK, so the question is: do we need both or would a
> >>>>>>>> mechanism just
> >>>>>>>>>>>> to extend
> >>>>>>>>>>>>> permissions be sufficient?
> >>>>>>>>>>>>
> >>>>>>>>>>>> I do believe that we need both in order to support pages
> >>>>>>>> having only
> >>>>>>>>>>>> the permissions required to support their intended use
> >>>>>>>> during the
> >>>>>>>>>>>> time the
> >>>>>>>>>>>> particular access is required. While technically it is
> >>>>>>>> possible to grant
> >>>>>>>>>>>> pages all permissions they may need during their lifetime it
> >>>>>>>> is safer to
> >>>>>>>>>>>> remove permissions when no longer required.
> >>>>>>>>>>>
> >>>>>>>>>>> So if we imagine a run-time: how EMODPR would be useful, and
> >>>>>>>> how using it
> >>>>>>>>>>> would make things safer?
> >>>>>>>>>>>
> >>>>>>>>>> In scenarios of JIT compilers, once code is generated into RW pages,
> >>>>>>>>>> modifying both PTE and EPCM permissions to RX would be a good
> >>>>>>>> defensive
> >>>>>>>>>> measure. In that case, EMODPR is useful.
> >>>>>>>>>
> >>>>>>>>> What is the exact threat we are talking about?
> >>>>>>>>
> >>>>>>>> To add: it should be *significantly* critical thread, given that not
> >>>>>>>> supporting only EAUG would leave us only one complex call pattern with
> >>>>>>>> EACCEPT involvement.
> >>>>>>>>
> >>>>>>>> I'd even go to suggest to leave EMODPR out of the patch set, and
> >>>>>>>> introduce
> >>>>>>>> it when there is PoC code for any of the existing run-time that
> >>>>>>>> demonstrates the demand for it. Right now this way too speculative.
> >>>>>>>>
> >>>>>>>> Supporting EMODPE is IMHO by factors more critical.
> >>>>>>>
> >>>>>>> At least it does not protected against enclave code because an enclave
> >>>>>>> can
> >>>>>>> always choose not to EACCEPT any of the EMODPR requests. I'm not only
> >>>>>>> confused here about the actual threat but also the potential adversary
> >>>>>>> and
> >>>>>>> target.
> >>>>>>>
> >>>>>> I'm not sure I follow your thoughts here. The sequence should be for enclave
> >>>>>> to request  EMODPR in the first place through runtime to kernel, then to
> >>>>>> verify with EACCEPT that the OS indeed has done EMODPR.
> >>>>>> If enclave does not verify with EACCEPT, then its own code has
> >>>>>> vulnerability. But this does not justify OS not providing the mechanism to
> >>>>>> request EMODPR.
> >>>>>
> >>>>> The question is really simple: what is the threat scenario? In order to use
> >>>>> the word "vulnerability", you would need one.
> >>>>>
> >>>>> Given the complexity of the whole dance with EMODPR it is mandatory to have
> >>>>> one, in order to ack it to the mainline.
> >>>>>
> >>>>
> >>>> Which complexity related to EMODPR are you concerned about? In a later message
> >>>> you mention "This leaves only EAUG and EMODT requiring the EACCEPT handshake"
> >>>> so it seems that you are perhaps concerned about the flow involving EACCEPT?
> >>>> The OS does not require nor depend on EACCEPT being called as part of these flows
> >>>> so a faulty or misbehaving user space omitting an EACCEPT call would not impact
> >>>> these flows in the OS, but would of course impact the enclave.
> >>>
> >>> I'd say *any* complexity because I see no benefit of supporting it. E.g.
> >>> EMODPR/EACCEPT/EMODPE sequence I mentioned to Haitao concerns me. How is
> >>> EMODPR going to help with any sort of workload?
> >>
> >> I've even started think should we just always allow mmap()?
> >
> > I suspect this may be the most ergonomic way forward. Instructions
> > like EAUG/EMODPR/etc are really irrelevant implementation details to
> > what the enclave wants, which is a memory mapping in the enclave. Why
> > make the enclave runner do multiple context switches just to change
> > the memory map of an enclave?
>
> The enclave runner is not forced to make any changes to a memory mapping. To start,
> this implementation supports and does not change the existing ABI where a new
> memory mapping can only be created if its permissions are the same or weaker
> than the EPCM permissions. After the memory mapping is created the EPCM permissions
> can change (thanks to SGX2) and when they do there are no forced nor required
> changes to the memory mapping - pages remain accessible where the memory mapping
> and EPCM permissions agree. It is true that if an enclave chooses to relax permissions
> to an enclave page (EMODPE) then the memory mapping may need to be changed as
> should be expected to access a page with permissions that the memory mapping
> did not previously allow.
>
> Are you saying that the permissions of a new memory mapping should now be allowed
> to exceed EPCM permissions and thus the enclave runner would not need to modify a
> memory mapping when EPCM permissions are relaxed? As mentioned above this may be
> considered a change in ABI but something we could support on SGX2 systems.
>
> I would also like to highlight Haitao's earlier comment that a foundation of SGX is
> that the OS is untrusted. The enclave owner does not trust the OS and needs EMODPR
> and EMODPE to manage enclave page permissions.

As I understand the problem, there are two permission sets:

 * The EPCM permissions
 * The mmap() permissions

The mmap() permissions cannot exceed the EPCM permissions, for obvious reasons.

Hypothesis: there is no practical reason the EPCM permissions should
exceed mmap() permissions.

If the hypothesis is true, then userspace shouldn't have an API to
manage EPCM permissions distinct from mmap() permissions. Instead,
userspace should just call mmap() and the kernel should internally
adjust the EPCM permissions to match the mmap() permissions. This has
a performance advantage that every permissions change is one syscall
rather than two.

So what is the use case where an enclave would want to restrict mmap()
permissions but not restrict EPCM?
