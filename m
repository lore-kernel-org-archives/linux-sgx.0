Return-Path: <SRS0=SAws=OH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79799C43441
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 10:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F707205C9
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Nov 2018 10:52:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F707205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=enjellic.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbeK1Vxp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 28 Nov 2018 16:53:45 -0500
Received: from wind.enjellic.com ([76.10.64.91]:55588 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbeK1Vxp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 28 Nov 2018 16:53:45 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id wASAnf6w023645;
        Wed, 28 Nov 2018 04:49:41 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id wASAnf5H023644;
        Wed, 28 Nov 2018 04:49:41 -0600
Date:   Wed, 28 Nov 2018 04:49:41 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Message-ID: <20181128104941.GA23077@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20181122111253.GA31150@wind.enjellic.com> <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com> <20181124172114.GB32210@linux.intel.com> <20181125145329.GA5777@linux.intel.com> <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net> <20181126215145.GC868@linux.intel.com> <20181126230436.GA6737@linux.intel.com> <20181127085533.GA12247@wind.enjellic.com> <20181127164129.GB4170@linux.intel.com> <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C11C9312-65BC-460A-8F9F-608E101AE5C1@amacapital.net>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 28 Nov 2018 04:49:42 -0600 (CST)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 27, 2018 at 09:55:45AM -0800, Andy Lutomirski wrote:

> > On Nov 27, 2018, at 8:41 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > 
> >> On Tue, Nov 27, 2018 at 02:55:33AM -0600, Dr. Greg wrote:
> >> Since the thread has become a bit divergent I wanted to note that we
> >> have offered a proposal for a general policy management framework
> >> based on MRSIGNER values.  This framework is consistent with the SGX
> >> security model, ie. cryptographic rather then DAC based policy
> >> controls.  This framework also allows a much more flexible policy
> >> implementation that doesn't result in combinatoric issues.
> >> 
> >> Our framework also allows the preservation of the current ABI which
> >> allows an EINITTOKEN to be passed in from userspace.  The framework
> >> also supports the ability to specify that only a kernel based launch
> >> enclave (LE) should be available if the platform owner or distribution
> >> should desire to implement such a model.
> >> 
> >> The policy management framework is straight forward.  Three linked
> >> lists or their equivalent which are populated through /sysfs
> >> pseudo-files or equivalent plumbing.  Each list is populated with
> >> MRSIGNER values for signing keys that are allowed to initialize
> >> enclaves under three separate conditions.
> >> 
> >> 1.) General enclaves without special attribute bits.
> >> 
> >> 2.) Enclaves with the SGX_FLAGS_PROVISION_KEY attribute set. - i.e.,
> >> 'Provisioning Enclaves'.
> >> 
> >> 3.) Enclaves with the SGX_FLAGS_LICENSE_KEY attribute set - i.e., 'Launch
> >> Enclaves'.
> >> 
> >> An all-null MRSIGNER value serves as a 'sealing' value that locks a
> >> list from any further modifications.
> >> 
> >> This architecture allows platform policies to be specified and then
> >> sealed at early boot by the root user.  At that point cryptographic
> >> policy controls are in place rather then DAC based controls, the
> >> latter of which have perpetual security liabilities in addition to the
> >> useability constraints inherent in a DAC or device node model.
> >> 
> >> We have developed an independent implementation of the PSW and
> >> arguably have as much experience with issues surrounding how to
> >> interact with the device driver as anyone.  We have spent a lot of
> >> time thinking about these issues and the above framework provides the
> >> most flexible architecture available.
> > 
> > Sounds like a lot bloat and policy added to the kernel whereas with
> > Andy's proposal you can implement logic to a daemon and provide only
> > mechanism to do it.

> Well, almost. We'd need SGX_IOC_FREEZE_MR{ENCLAVE,SIGNER} or
> similar.  Or maybe the daemon could handle the entire loading process.
> But this can wait until after the main driver is upstream.
>
> This does lead to a question: enclaves are kind-of-sort-of mapped
> into a given address space. What happens if you issue the various
> ioctls in the context of a different mm?  For that matter, can two
> processes mmap the same enclave?

Fascinating.

We've been carrying a patch, that drops in on top of the proposed
kernel driver, that implements the needed policy management framework
for DAC fragile (FLC) platforms.  After a meeting yesterday with the
client that is funding the work, a decision was made to release the
enhancements when the SGX driver goes mainline.  That will at least
give developers the option of creating solutions on Linux that
implement the security guarantees that SGX was designed to deliver.

Most importantly, since it implements a driver consistent with the
design of SGX, it has the added benefit of allowing system
administrators the ability to enable the driver to work on non-FLC
(locked) platforms.  Since Jarkko confirmed that FLC is the option of
platform vendors, this would seem to be important as SGX on Linux will
only work in a random fashion dependent on the whims of hardware OEM's
in probably a SKU dependent fashion.  Which is why the client has
interest in the work.

Best wishes for a productive remainder of the week.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Five year projections, are you kidding me.  We don't know what we are
 supposed to be doing at the 4 o'clock meeting this afternoon."
                                -- Terry Wieland
                                   Resurrection
