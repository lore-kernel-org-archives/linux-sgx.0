Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1555C43444
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 15:08:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F24121852
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 15:08:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbeLRPIQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 10:08:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:22909 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbeLRPIQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 10:08:16 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 07:08:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,368,1539673200"; 
   d="scan'208";a="284574208"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.154])
  by orsmga005.jf.intel.com with ESMTP; 18 Dec 2018 07:08:15 -0800
Date:   Tue, 18 Dec 2018 07:08:15 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: [RFC PATCH v5 0/5] x86: Add vDSO exception fixup for SGX
Message-ID: <20181218150815.GB28326@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <20181218041815.GA5097@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218041815.GA5097@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Dec 18, 2018 at 06:18:15AM +0200, Jarkko Sakkinen wrote:
> On Fri, Dec 14, 2018 at 01:57:24PM -0800, Sean Christopherson wrote:
> > __vdso_sgx_enter_enclave() gets another rewrite, this time to strip
> > it down to the bare minimum and explicitly break compliance with the
> > x86-64 ABI.  Feedback from v4 revealed that __vdso_sgx_enter_enclave()
> > would need to save (a lot) more than just the non-volatile GPRs to be
> > compliant with the x86-64 ABI, at which point breaking from the ABI
> > completely became much more palatable.
> > 
> > The non-standard ABI also solves the question of "which GPRs should be
> > marshalled to/from the enclave" by getting out of the way entirely and
> > letting userspace have free reign (except for RSP, which has a big ol'
> > DO NOT TOUCH sign on it).
> 
> Can you share a reference, or is this better documented in the
> accompanied patches?

Patch 5/5 has more details, and v4 of the series has a lot of background
info by way of discussion:

https://lkml.kernel.org/r/20181213213135.12913-1-sean.j.christopherson@intel.com
