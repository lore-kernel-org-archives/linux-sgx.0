Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FBDC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jan 2022 20:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiAMUJv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiAMUJv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 13 Jan 2022 15:09:51 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59A7C06161C
        for <linux-sgx@vger.kernel.org>; Thu, 13 Jan 2022 12:09:50 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id a8so8143728qvx.2
        for <linux-sgx@vger.kernel.org>; Thu, 13 Jan 2022 12:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yi9esiTlCgWbOHCclaPAeAVOlg1T89LuZMSGa18wANQ=;
        b=ZoPfDaCFkJlUJLqe/T4eQ4TD1RbZGxjn4BpPTcGnjqeHaFTs8ZhVDqBHMoLv1zcu0k
         EHjAx3XUvnIlqkJNzmhzbI2G2XbiNkjhjwWye5A05WUHWUkEn/zbkrrcSe74cPcgIIVe
         c6r6VLey3zltr492BrTuSZdSDQul+bJyB4Kc/D3GGQb2JH70ugIYvahOPE8NoQSonLBO
         M1NOceMIZP3yiv+WS3DqIuHkkB/dpgPlCljGoz66wuCMETEQhUoIDwfsXbkn/BmPsEO4
         g8dRy1VVZTWj6m9c6weWUW+5UvokLIzxqdk5vCBFBxQcXHn2e+jHIC7COHoecvla8i6w
         QAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yi9esiTlCgWbOHCclaPAeAVOlg1T89LuZMSGa18wANQ=;
        b=geTgb5KQVQ+472aF9ftKMTjugDUrLvsL9jB7nPI6Uwjqkt2clhNZjbPTKDYBfsx35r
         RVWLjtrkMm+Bb3s9B5/FcZaN5A1k0s8GKWEsvBfQ4TpizUyhtnhsCwkXUsh1ZdqBI5dL
         EIG8yBVyKMp3IyY/ODZdD/BCuhXud514cLGElFX7dJEuToRPa3nMsIGk4tshBvPhzabd
         C5PP3xqehXwhLxKfnv+kVIumJEf3hym3PSHuFH5YcQn2bmAQ9NwrLhIKyQsLbDJs6Bi8
         rZ0MXfG9HmaVHaXYp3mO9rmIvRr/jkHTzAlCzyVfz+qo9SJ5/pxw9BSJgPIACcoQoUo1
         OnUQ==
X-Gm-Message-State: AOAM5308HfvVmR0MBDnIdiBO7BdF5tRiY7+7vcZ7l/boNyiqlX4jOX0+
        fVAqpbYqCU/+24utr8fD0wNVYFlRLpcoNONAnnTNvg==
X-Google-Smtp-Source: ABdhPJyQPRm/IuremZPFZcTaDwnILaE/JdYh4Br64+4hNUEotxJtqf3IAYCyV5l/5fnciih9ut+E1Jgyo6dcJW0ifV0=
X-Received: by 2002:a05:6214:29e2:: with SMTP id jv2mr5422072qvb.42.1642104589627;
 Thu, 13 Jan 2022 12:09:49 -0800 (PST)
MIME-Version: 1.0
References: <573e0836-6ac2-30a4-0c21-d4763707ac96@intel.com>
 <YdgvFTIRboHwTgRT@iki.fi> <op.1fmvdehpwjvjmi@hhuan26-mobl1.mshome.net>
 <YdmxpTVM1JG8nxQ3@iki.fi> <YdmzDy1BOHgh8CII@iki.fi> <Ydm6RiIwuh3IspRI@iki.fi>
 <op.1fsvkfiwwjvjmi@hhuan26-mobl1.mshome.net> <YdzjEzjF0YKn+pZ6@iki.fi>
 <4195402f-cbf9-bc75-719d-22cea8e36e60@intel.com> <Yd9pMq4lUy56B+50@iki.fi> <Yd9qmMx7NO450mzZ@iki.fi>
In-Reply-To: <Yd9qmMx7NO450mzZ@iki.fi>
From:   Nathaniel McCallum <nathaniel@profian.com>
Date:   Thu, 13 Jan 2022 15:09:38 -0500
Message-ID: <CAHAy0tRi2q+wG+yBttq0FYeK-5wUAoK_=ZCtWsfQf0m8oPc1-w@mail.gmail.com>
Subject: Re: [PATCH 05/25] x86/sgx: Introduce runtime protection bits
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
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

On Wed, Jan 12, 2022 at 6:56 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
>
> On Thu, Jan 13, 2022 at 01:50:13AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Jan 11, 2022 at 09:13:27AM -0800, Reinette Chatre wrote:
> > > Hi Jarkko,
> > >
> > > On 1/10/2022 5:53 PM, Jarkko Sakkinen wrote:
> > > > On Mon, Jan 10, 2022 at 04:05:21PM -0600, Haitao Huang wrote:
> > > >> On Sat, 08 Jan 2022 10:22:30 -0600, Jarkko Sakkinen <jarkko@kernel.org>
> > > >> wrote:
> > > >>
> > > >>> On Sat, Jan 08, 2022 at 05:51:46PM +0200, Jarkko Sakkinen wrote:
> > > >>>> On Sat, Jan 08, 2022 at 05:45:44PM +0200, Jarkko Sakkinen wrote:
> > > >>>>> On Fri, Jan 07, 2022 at 10:14:29AM -0600, Haitao Huang wrote:
> > > >>>>>>>>> OK, so the question is: do we need both or would a
> > > >>>> mechanism just
> > > >>>>>>>> to extend
> > > >>>>>>>>> permissions be sufficient?
> > > >>>>>>>>
> > > >>>>>>>> I do believe that we need both in order to support pages
> > > >>>> having only
> > > >>>>>>>> the permissions required to support their intended use
> > > >>>> during the
> > > >>>>>>>> time the
> > > >>>>>>>> particular access is required. While technically it is
> > > >>>> possible to grant
> > > >>>>>>>> pages all permissions they may need during their lifetime it
> > > >>>> is safer to
> > > >>>>>>>> remove permissions when no longer required.
> > > >>>>>>>
> > > >>>>>>> So if we imagine a run-time: how EMODPR would be useful, and
> > > >>>> how using it
> > > >>>>>>> would make things safer?
> > > >>>>>>>
> > > >>>>>> In scenarios of JIT compilers, once code is generated into RW pages,
> > > >>>>>> modifying both PTE and EPCM permissions to RX would be a good
> > > >>>> defensive
> > > >>>>>> measure. In that case, EMODPR is useful.
> > > >>>>>
> > > >>>>> What is the exact threat we are talking about?
> > > >>>>
> > > >>>> To add: it should be *significantly* critical thread, given that not
> > > >>>> supporting only EAUG would leave us only one complex call pattern with
> > > >>>> EACCEPT involvement.
> > > >>>>
> > > >>>> I'd even go to suggest to leave EMODPR out of the patch set, and
> > > >>>> introduce
> > > >>>> it when there is PoC code for any of the existing run-time that
> > > >>>> demonstrates the demand for it. Right now this way too speculative.
> > > >>>>
> > > >>>> Supporting EMODPE is IMHO by factors more critical.
> > > >>>
> > > >>> At least it does not protected against enclave code because an enclave
> > > >>> can
> > > >>> always choose not to EACCEPT any of the EMODPR requests. I'm not only
> > > >>> confused here about the actual threat but also the potential adversary
> > > >>> and
> > > >>> target.
> > > >>>
> > > >> I'm not sure I follow your thoughts here. The sequence should be for enclave
> > > >> to request  EMODPR in the first place through runtime to kernel, then to
> > > >> verify with EACCEPT that the OS indeed has done EMODPR.
> > > >> If enclave does not verify with EACCEPT, then its own code has
> > > >> vulnerability. But this does not justify OS not providing the mechanism to
> > > >> request EMODPR.
> > > >
> > > > The question is really simple: what is the threat scenario? In order to use
> > > > the word "vulnerability", you would need one.
> > > >
> > > > Given the complexity of the whole dance with EMODPR it is mandatory to have
> > > > one, in order to ack it to the mainline.
> > > >
> > >
> > > Which complexity related to EMODPR are you concerned about? In a later message
> > > you mention "This leaves only EAUG and EMODT requiring the EACCEPT handshake"
> > > so it seems that you are perhaps concerned about the flow involving EACCEPT?
> > > The OS does not require nor depend on EACCEPT being called as part of these flows
> > > so a faulty or misbehaving user space omitting an EACCEPT call would not impact
> > > these flows in the OS, but would of course impact the enclave.
> >
> > I'd say *any* complexity because I see no benefit of supporting it. E.g.
> > EMODPR/EACCEPT/EMODPE sequence I mentioned to Haitao concerns me. How is
> > EMODPR going to help with any sort of workload?
>
> I've even started think should we just always allow mmap()?

I suspect this may be the most ergonomic way forward. Instructions
like EAUG/EMODPR/etc are really irrelevant implementation details to
what the enclave wants, which is a memory mapping in the enclave. Why
make the enclave runner do multiple context switches just to change
the memory map of an enclave?

> The worst thing
> that can happen is that the enclave crashes. Does that matter all that
> much? I'm asking because access control is the main theme in SGX2 patch set
> that IMHO should be considered to the ground. It really "stress tests" that
> area. If we can settle on  that, then other things are just technical details
> that we can surely sort out.
>
> /Jarkko
