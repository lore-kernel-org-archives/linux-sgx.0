Return-Path: <SRS0=WNLm=S7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5959AC43219
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Apr 2019 19:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33E0C20675
	for <linux-sgx@archiver.kernel.org>; Mon, 29 Apr 2019 19:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfD2TI6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 29 Apr 2019 15:08:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:16938 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbfD2TI6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 29 Apr 2019 15:08:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 12:08:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="139872081"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga006.jf.intel.com with ESMTP; 29 Apr 2019 12:08:57 -0700
Date:   Mon, 29 Apr 2019 12:08:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-ID: <20190429190857.GD31379@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-16-jarkko.sakkinen@linux.intel.com>
 <20190422215831.GL1236@linux.intel.com>
 <6dd981a7-0e38-1273-45c1-b2c0d8bf6fed@fortanix.com>
 <20190424002653.GB14422@linux.intel.com>
 <77cface6-dcc4-7e26-9910-ea9d13152531@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77cface6-dcc4-7e26-9910-ea9d13152531@fortanix.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 24, 2019 at 01:04:21AM +0000, Jethro Beekman wrote:
> On 2019-04-23 17:26, Sean Christopherson wrote:
> >On Tue, Apr 23, 2019 at 11:29:24PM +0000, Jethro Beekman wrote:
> >>On 2019-04-22 14:58, Sean Christopherson wrote:
> >>>Now that the core SGX code is approaching stability, I'd like to start
> >>>sending RFCs for the EPC virtualization and KVM bits to hash out that side
> >>>of things.  The ACPI crud is the last chunk of code that would require
> >>>non-trivial changes to the core SGX code for the proposed virtualization
> >>>implementation.  I'd strongly prefer to get it out of the way before
> >>>sending the KVM RFCs.
> >>
> >>What kind of changes? Wouldn't KVM just be another consumer of the same API
> >>used by the driver?
> >
> >Nope, userspace "only" needs to be able to mmap() arbitrary chunks of EPC.
> 
> I don't think this is sufficient. Don't you need enclave tracking in order
> to support paging?

The plan is to not support graceful EPC reclaim in the host on platforms
without VMM oversubscription extensions, e.g. ENCLV, ERDINFO, etc..., due
to the complexity and performance overhead.  Mostly the complexity.

And if reclaim were to be supported without the extensions, it would be
done without exiting to userspace on every ENCLS instruction.
