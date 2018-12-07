Return-Path: <SRS0=sJTe=OQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E60C07E85
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 20:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367562082D
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Dec 2018 20:35:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 367562082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbeLGUf7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Dec 2018 15:35:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:44606 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbeLGUf6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Dec 2018 15:35:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Dec 2018 12:35:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,327,1539673200"; 
   d="scan'208";a="97045321"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga007.jf.intel.com with ESMTP; 07 Dec 2018 12:35:57 -0800
Date:   Fri, 7 Dec 2018 12:35:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-sgx@vger.kernel.org, haitao.huang@linux.intel.com,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr. Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v2 4/4] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20181207203557.GF10404@linux.intel.com>
References: <20181206221922.31012-1-sean.j.christopherson@intel.com>
 <20181206221922.31012-5-sean.j.christopherson@intel.com>
 <CALCETrXRJ645=08fyeoMQ949fLB1TvhsgERFVx5mAHdViEjq8Q@mail.gmail.com>
 <20181207165145.GB10404@linux.intel.com>
 <CALCETrVkEW82PzQZhJ5iS849DLY1gbd8YjH5F7P1J7hgjkjiOQ@mail.gmail.com>
 <20181207190257.GC10404@linux.intel.com>
 <EFA99261-BE93-49DA-9A8F-E6FD28069AFC@amacapital.net>
 <20181207200935.GE10404@linux.intel.com>
 <4CEB5945-9562-40FA-8CCA-A1675D55B001@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEB5945-9562-40FA-8CCA-A1675D55B001@amacapital.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 07, 2018 at 12:16:59PM -0800, Andy Lutomirski wrote:
> 
> > On Dec 7, 2018, at 12:09 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> > 
> > Speaking of preserving registers, the asm blob needs to mark RBX as
> > clobbered since it's modified for EEXIT.
> 
> Have fun with that.  The x86_32 compiler seems to really like having its
> PIC register preserved, and you may get some lovely compiler errors.

Tagentinally related, as-is the SGX vDSO is only compiled for x86_64
since CONFIG_SGX depends on CONFIG_X86_64.  Mapping the EPC in 32-bit
mode complicates things and no one is asking for SGX support on 32-bit
builds, so...
