Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9ACC28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 21:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3279920874
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 21:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFEV2x (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 17:28:53 -0400
Received: from wind.enjellic.com ([76.10.64.91]:34676 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbfFEV2w (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 17:28:52 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x55LPbvS022703;
        Wed, 5 Jun 2019 16:25:37 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x55LPbpR022702;
        Wed, 5 Jun 2019 16:25:37 -0500
Date:   Wed, 5 Jun 2019 16:25:37 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "rientjes@google.com" <rientjes@google.com>
Subject: Re: [PATCH v20 15/28] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190605212536.GA22510@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com> <20190422215831.GL1236@linux.intel.com> <6dd981a7-0e38-1273-45c1-b2c0d8bf6fed@fortanix.com> <20190424002653.GB14422@linux.intel.com> <20190604201232.GA7775@linux.intel.com> <20190605142908.GD11331@linux.intel.com> <20190605145219.GC26328@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605145219.GC26328@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Wed, 05 Jun 2019 16:25:37 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 07:52:19AM -0700, Sean Christopherson wrote:

Good afternoon to everyone.

> At this point I don't see the access control stuff impacting the LKM
> decision.
> 
> Irrespetive of the access control thing, there are (at least) two issues
> with using ACPI to probe the driver:
> 
>   - ACPI probing breaks if there are multiple device, i.e. when KVM adds
>     a raw EPC device.  We could do something like probe the driver via
>     ACPI but manually load the raw EPC device from core SGX code, but IMO
>     taking that approach should be a concious decision.

If that is the case, I assume that ACPI probing will also be
problematic for kernels that will be running on systems that have the
SGX accelerator cards that Intel has announced in them.

We haven't seen a solid technical description regarding how SGX
functionality is to be surfaced via these cards.  However, since the
SDM/SGX specification indicates that multiple PRM/EPC's are supported,
the logical assumption would be that each card would be surfaced as a
separate EPC's.

The focus of this driver will be largely cloud based environments and
the accelerator cards are designed to fill the gap until multi-socket
SGX support is available, which has been 'real soon now' for about
three years.  So it would seem to be a requirement for the driver to
deal with these cards if it is to be relevant.

>   - ACPI probing means core SGX will consume resources for EPC management
>     even if there is no end consumer, e.g. the driver refuses to load due
>     to lack of FLC support.

It isn't relevant to these conversations but there will be a version
of this driver supported that runs on non-FLC platforms and that will
support full hardware root of trust via launch enclaves.

Have a good evening.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"System Administration is a few hours of boredom followed by several
 moments of intense fear."
                                -- Tom ONeil
