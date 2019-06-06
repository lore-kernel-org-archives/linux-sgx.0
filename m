Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E1FC28EB4
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 15:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 282782083E
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 15:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfFFPdJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Jun 2019 11:33:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:24534 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbfFFPdJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Jun 2019 11:33:09 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:33:07 -0700
X-ExtLoop1: 1
Received: from harend-mobl.ger.corp.intel.com (HELO localhost) ([10.252.33.8])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2019 08:32:56 -0700
Date:   Thu, 6 Jun 2019 18:32:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20190606153230.GA25112@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
 <20190422215831.GL1236@linux.intel.com>
 <6dd981a7-0e38-1273-45c1-b2c0d8bf6fed@fortanix.com>
 <20190424002653.GB14422@linux.intel.com>
 <20190604201232.GA7775@linux.intel.com>
 <20190605142908.GD11331@linux.intel.com>
 <20190605145219.GC26328@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605145219.GC26328@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 07:52:19AM -0700, Sean Christopherson wrote:
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
> 
>   - ACPI probing means core SGX will consume resources for EPC management
>     even if there is no end consumer, e.g. the driver refuses to load due
>     to lack of FLC support.
> 
> It would be very helpful for us to make a decision about LKM support
> sooner rather than later, e.g. to start reworking the core code now and so
> that I can send RFCs for KVM support.  IMO we're just delaying the
> inevitable and slowing down upstreaming in the process.

I think a good reason to not have LKM is that it can be added after
reaching the mainline if there ever becomes strong enough reasons to
do so.

I have similar situation with TPM where TPM core would better be just
part of the core but since tristate was introduced, it is hard to revert
that decision.

I would prefer do this update myself rather than taking patches as it
takes me probably shorter time to implement the change rather than
reviewing and squashing patches. I'll get it done ASAP.

/Jarkko
