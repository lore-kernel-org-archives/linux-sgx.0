Return-Path: <SRS0=MviC=6O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DF5C83009
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 08:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B5420784
	for <linux-sgx@archiver.kernel.org>; Thu, 30 Apr 2020 08:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD3IXm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 Apr 2020 04:23:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:1644 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgD3IXm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 Apr 2020 04:23:42 -0400
IronPort-SDR: R97pwFDK+xNwl81j/ZLTw6OqRp+U2qLwPspqgGJ549wRH9rXa5CmLgZWYC4se7OWoIvDjiVZ1N
 +u4sCm1/20pw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2020 01:23:41 -0700
IronPort-SDR: 36p3/H3GepOLsOJEQt0w0FBY0ss06P1xezuXnKqxyXQBc+HUgDEi1e/HICvGtWCGRK6kmF06/F
 6HphBVn0Ibuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,334,1583222400"; 
   d="scan'208";a="258225161"
Received: from smirnovi-mobl.ccr.corp.intel.com (HELO localhost) ([10.252.55.1])
  by orsmga003.jf.intel.com with ESMTP; 30 Apr 2020 01:23:34 -0700
Date:   Thu, 30 Apr 2020 11:23:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200430082328.GA6387@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <07c1a36c-cebc-3a65-6f92-4a5498fcc369@fortanix.com>
 <20200430034651.GB31820@linux.intel.com>
 <a9ff7817-32d1-e048-af05-862ca9f8aa46@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9ff7817-32d1-e048-af05-862ca9f8aa46@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Apr 30, 2020 at 09:19:48AM +0200, Jethro Beekman wrote:
> On 2020-04-30 05:46, Jarkko Sakkinen wrote:
> > On Wed, Apr 29, 2020 at 05:27:48PM +0200, Jethro Beekman wrote:
> >> On 2020-04-21 23:52, Jarkko Sakkinen wrote:
> >>> Intel(R) SGX is a set of CPU instructions that can be used by applications
> >>> to set aside private regions of code and data. The code outside the enclave
> >>> is disallowed to access the memory inside the enclave by the CPU access
> >>> control.
> >>>
> >>> There is a new hardware unit in the processor called Memory Encryption
> >>> Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
> >>> one or many MEE regions that can hold enclave data by configuring them with
> >>> PRMRR registers.
> >>>
> >>> The MEE automatically encrypts the data leaving the processor package to
> >>> the MEE regions. The data is encrypted using a random key whose life-time
> >>> is exactly one power cycle.
> >>>
> >>> The current implementation requires that the firmware sets
> >>> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
> >>> decide what enclaves it wants run. The implementation does not create
> >>> any bottlenecks to support read-only MSRs later on.
> >>>
> >>> You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> >>>
> >>> 	cat /proc/cpuinfo  | grep sgx
> >>
> >> Let's merge this.
> > 
> > So can I tag reviewed-by's?
> > 
> 
> No, but you already have my tested-by's.
> 
> If it helps I can try to review some patches, but 1) I know nothing
> about kernel coding guidelines and best practices and 2) I know little
> about most kernel internals, so I won't be able to review every patch.

Ackd-by *acknowledges* that the patches work for you. I think that would
be then the correct choice for the driver patch and patches before that.

Lets go with that if that is cool for you of course.

Did you run the selftest only or possibly also some internal Fortanix
tests?

/Jarkko
