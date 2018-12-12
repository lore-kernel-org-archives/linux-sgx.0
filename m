Return-Path: <SRS0=VhMv=OV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3B2C6783B
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Dec 2018 02:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 275B220855
	for <linux-sgx@archiver.kernel.org>; Wed, 12 Dec 2018 02:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 275B220855
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbeLLCps (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 Dec 2018 21:45:48 -0500
Received: from wind.enjellic.com ([76.10.64.91]:56906 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbeLLCps (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 Dec 2018 21:45:48 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wBC2gkBM028859;
        Tue, 11 Dec 2018 20:42:46 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wBC2gk8w028858;
        Tue, 11 Dec 2018 20:42:46 -0600
Date:   Tue, 11 Dec 2018 20:42:46 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>
Subject: Re: [RFC PATCH v3 0/4] x86: Add exception fixup for SGX ENCLU
Message-ID: <20181212024246.GA28530@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com> <20181210232449.GA11843@localhost> <EEE078E7-7F37-4F74-8874-46E16C1E0A77@amacapital.net> <20181211165253.GB14731@linux.intel.com> <CALCETrXOXh8Gb_d7NYLakx4w+JVEe79t11wFPLpy+5MEq9kq=A@mail.gmail.com> <20181211222312.GI14731@linux.intel.com> <CALCETrW5Z_4+Yo+D1KgahHHqGdb+tgyWMRvB8eozbW82jZqK3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW5Z_4+Yo+D1KgahHHqGdb+tgyWMRvB8eozbW82jZqK3w@mail.gmail.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 11 Dec 2018 20:42:46 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 11, 2018 at 03:10:52PM -0800, Andy Lutomirski wrote:

Good evening, I hope the day has gone well for everyone.

> > > > On Dec 11, 2018, at 8:52 AM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > This isn't fundamentally different than forcing all EENTER
> > > > calls through the vDSO, which is also per-process.
> > > > Technically this is more flexible in that regard since
> > > > userspace gets to choose where their one ENCLU gets to reside.
> > > > Userspace can have per-enclave entry flows so long as the
> > > > actual ENLU[EENTER] is common, same as vDSO.

> > > Right. The problem is that user libraries have a remarkably hard
> > > time agreeing on where their one copy of anything lives.

> > Are you concerned about userspace shooting themselves in the foot,
> > e.g.  unknowingly overwriting their handler?  Requiring
> > unregister->register to change the handler would mitigate that
> > issue for the most part.  Or we could even say it's a write-once
> > property.
> >
> > That obviously doesn't solve the issue of a userspace application
> > deliberately using two different libraries to run enclaves in a
> > single process, but I have a hard time envisioning a scenario
> > where someone would want to use two different *SGX* libraries in a
> > single process.  Don't most of the signal issue arise due to
> > loading multiple libraries that provide *different* services
> > needing to handle signals?

> I can easily imagine two SGX libraries that know nothing about each
> other running in the same process.  One or both could be PKCS#11
> modules, for example.

Very good, I see that Sean agreed with this down thread.  I was
concerned that our discussion was lacking precision and we were
talking past one another.

> I suspect that Linux will eventually want the ability for libraries
> to register exception handlers, but that's not going to get designed
> and implemented quickly enough for SGX's initial Linux rollout.  A
> vDSO helper like in your earlier series should solve most of the
> problem without any contention issues.

Let me see if I can impart some framework for additional clarity as
discussions proceed forward.

I believe it would be helpful if we could agree to refer to a body of
code, possibly in library form, that loads, initializes and executes
an enclave as an 'SGX runtime'.  In this framework, the term 'library'
refers to code that an application links to for domain specific
functionality, ie. libpkcs11, libkrb5, libsasl.  These 'libraries' may
implement enclaves, using 'SGX runtimes' of their choice, to improve
their security guarantees.

In this model it is the 'SGX runtime' that is responsible for
registering SGX exception handlers under their management.

In order for mainline Linux SGX support to be relevant, it must admit
mutually distrusting 'SGX runtimes' in the same process context.  The
SGX exception handler architecture must also support the notion of
'nested enclave' invocation where an enclave may execute an OCALL and
then go on to execute an enclave, possibly based on a different 'SGX
runtime', before returning into its previous enclave.

Hopefully the above will help assist further discussions.

Have a good evening.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If you think nobody cares if you're alive, try missing a couple of car
 payments."
                                -- Earl Wilson
