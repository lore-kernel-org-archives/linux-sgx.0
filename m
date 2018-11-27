Return-Path: <SRS0=TXuC=OG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCB0C43441
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 08:56:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F59F208E4
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Nov 2018 08:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F59F208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbeK0TxV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:53:21 -0500
Received: from wind.enjellic.com ([76.10.64.91]:55482 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729259AbeK0TxV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Nov 2018 14:53:21 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wAR8tX2x012665;
        Tue, 27 Nov 2018 02:55:33 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wAR8tXnX012664;
        Tue, 27 Nov 2018 02:55:33 -0600
Date:   Tue, 27 Nov 2018 02:55:33 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr. Greg Wettstein" <greg@enjellic.com>, X86 ML <x86@kernel.org>,
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
Message-ID: <20181127085533.GA12247@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181119161917.GF13298@linux.intel.com> <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com> <20181120120442.GA22172@linux.intel.com> <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com> <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181126215145.GC868@linux.intel.com> <20181126230436.GA6737@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126230436.GA6737@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 27 Nov 2018 02:55:34 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Nov 26, 2018 at 03:04:36PM -0800, Jarkko Sakkinen wrote:

Good morning to everyone.

> On Mon, Nov 26, 2018 at 01:51:45PM -0800, Jarkko Sakkinen wrote:
> > > ioctl(sgx, SGX_IOC_ADD_RIGHT, sgx_provisioning);
> > > 
> > > This requires extra syscalls, but it doesn???t have the combinatorial
> > > explosion problem.
> > 
> > I like this design because it is extendable. I'm now also in the same
> > page why we need to protect provisioning in the first place. I would
> > slight restructure this as
> > 
> > /dev/sgx/control
> > /dev/sgx/attributes/provision

> I guess it would be OK to upstream only control node first as long
> as provision attribute is denied in order to keep the already huge
> patch set a tiny bit smaller?

At this point in time I believe there is a consensus that the driver
needs a policy management framework of some type for an optimum
implementation.  The PROVISION attribute has privacy implications and
unrestricted access to release mode (full security) is problematic.

Since the thread has become a bit divergent I wanted to note that we
have offered a proposal for a general policy management framework
based on MRSIGNER values.  This framework is consistent with the SGX
security model, ie. cryptographic rather then DAC based policy
controls.  This framework also allows a much more flexible policy
implementation that doesn't result in combinatoric issues.

Our framework also allows the preservation of the current ABI which
allows an EINITTOKEN to be passed in from userspace.  The framework
also supports the ability to specify that only a kernel based launch
enclave (LE) should be available if the platform owner or distribution
should desire to implement such a model.

The policy management framework is straight forward.  Three linked
lists or their equivalent which are populated through /sysfs
pseudo-files or equivalent plumbing.  Each list is populated with
MRSIGNER values for signing keys that are allowed to initialize
enclaves under three separate conditions.

1.) General enclaves without special attribute bits.

2.) Enclaves with the SGX_FLAGS_PROVISION_KEY attribute set. - i.e.,
'Provisioning Enclaves'.

3.) Enclaves with the SGX_FLAGS_LICENSE_KEY attribute set - i.e., 'Launch
Enclaves'.

An all-null MRSIGNER value serves as a 'sealing' value that locks a
list from any further modifications.

This architecture allows platform policies to be specified and then
sealed at early boot by the root user.  At that point cryptographic
policy controls are in place rather then DAC based controls, the
latter of which have perpetual security liabilities in addition to the
useability constraints inherent in a DAC or device node model.

We have developed an independent implementation of the PSW and
arguably have as much experience with issues surrounding how to
interact with the device driver as anyone.  We have spent a lot of
time thinking about these issues and the above framework provides the
most flexible architecture available.

> /Jarkko

We would be happy to discuss specific aspects of the implementation.

Have a good day.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Remember that when you take down the fishhouse you can't put
 the minnows back into the lake, so throw them out on the ice.
 Make sure you stomp on any of the live ones so they don't suffer."
                                -- Fritz Wettstein
                                   At the lake
