Return-Path: <SRS0=WnqF=OD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0C25C43441
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 20:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F05920868
	for <linux-sgx@archiver.kernel.org>; Sat, 24 Nov 2018 20:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F05920868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbeKYHFK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 25 Nov 2018 02:05:10 -0500
Received: from wind.enjellic.com ([76.10.64.91]:55114 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbeKYHFK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 25 Nov 2018 02:05:10 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wAOKDJgn012412;
        Sat, 24 Nov 2018 14:13:19 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wAOKDIfi012411;
        Sat, 24 Nov 2018 14:13:18 -0600
Date:   Sat, 24 Nov 2018 14:13:18 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181124201318.GB12149@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com> <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124172114.GB32210@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 24 Nov 2018 14:13:19 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Nov 24, 2018 at 09:21:14AM -0800, Jarkko Sakkinen wrote:
> On Thu, Nov 22, 2018 at 07:21:08AM -0800, Andy Lutomirski wrote:
> > > At a high level, addressing these issues is straight forward.  First,
> > > the driver needs to support authorization equivalent to that which is
> > > implemented in the current Intel Launch Enclave, ie. control over the
> > > SGX_FLAGS_PROVISION_KEY attribute.
> > 
> > I agree, hence my email :)

> Started to scratch my head that is it really an issue that any
> enclave can provision in the end?
>
> Direct quote from your first response:
>
> "In particular, the ability to run enclaves with the provisioning
> bit set is somewhat sensitive, since it effectively allows access to
> a stable fingerprint of the system."
>
> As can be seen from the key derivation table this does not exactly
> hold so you should refine your original argument before we can
> consider any type of change.
>
> I just don't see what it is so wrong for any enclave to be able to
> tell that it really is an enclave.

This isn't about an enclave being able to tell that it is really an
enclave.  As I noted in my previous reply, access to the provisioning
bit allows an enclave author to create a perpetual hardware identifier
for a platform based on a signing key of their choosing, along with a
few other incidentals, all of which are completely under the control
of the enclave author.

The Intel SGX architects, at least originally, felt strongly enough
about this issue to use the Launch Enclave to implement
cryptographically secure policy control over access to the
SGX_FLAGS_PROVISION_KEY attribute.  See the 'if' clause that begins on
line 219 of psw/ae/le/launch_enclave.cpp in the current HEAD of the
Linux SGX SDK which is currently bf22963411.

Let me describe an entirely contrived example but one which is
representative of the threat.

I'm a web-site that wants to consistently and reliably track platforms
that visit a site.  Without cryptographically secure policy
enforcement in the SGX eco-system I push an enclave to the platform
which only computes the MRSIGNER specific derived provisioning key and
returns it to the web-site.

From that point onward I will always be able to identify the platform,
as long as the enclave can be executed on the platform.  Unlike
cookies, there is nothing to delete since the aggressor enclave only
needs to exist long enough to be run and generate the derived
provisioning key, no trace of the fingerprinting remains thereafter.

If the proposed driver is to be a functional replacement for the
existing SGX eco-system it needs to offer privacy and platform
security guarantees at least comparable to what is available on a
non-FLC system.  That means at least some semblance of
cryptographically secure policy management on at least two fronts.

We can propose a general architecture that we believe satisfies these
needs without compromising the upstream integrity of the kernel with
respect to free and open systems.  A solution that could arguably
protect user's investment in current non-FLC hardware as well.

We would be happy to articulate the outline of that but I don't want
to waste anyone's time, including ours, if everyone's mind has been
made up as to what the driver should and should not do.

We are clearly capable of making the proposed driver do whatever we
want it to do.  Our concern is that Linux security architects that
choose to use this technology have the best tools available to them,
within the constraints of upstream sensibility, without whacking on
the kernel.

As it stands now the driver has both privacy and potential system
security issues which translate into useability and desirability
implications for SGX on Linux moving forward.

> /Jarkko

Have a good remainder of the weekend.

I need to get back to my MIG welder out in the shop.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Attendants at a service station in Eunice, Louisiana, handed more than
 $100 to a naked man who claimed to have a gun in his pocket."
                                -- Unknown

