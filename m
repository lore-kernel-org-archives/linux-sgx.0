Return-Path: <SRS0=JJHd=2X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E8CC2D0DC
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 16:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5799720692
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Jan 2020 16:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgABQyO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:54:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:10317 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbgABQyO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Jan 2020 11:54:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jan 2020 08:54:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="216549206"
Received: from krominsx-mobl.ger.corp.intel.com (HELO localhost) ([10.252.21.64])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jan 2020 08:54:11 -0800
Date:   Thu, 2 Jan 2020 18:54:12 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v25] x86/sgx: Move SGX sub-feature bits to their own
 word
Message-ID: <20200102165412.GA17637@linux.intel.com>
References: <20191220230829.24047-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220230829.24047-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 20, 2019 at 03:08:29PM -0800, Sean Christopherson wrote:
> As requested by Boris, move the CPUID 0x12 features to their own word in
> cpufeatures.
> 
> This can be squashed cleanly with commit c3eac55d3882 ("x86/cpufeatures:
> x86/msr: Add Intel SGX hardware bits"), replacing paragraph
> 
>   Remap CPUID.(EAX=12H, ECX=0) bits to the Linux fake CPUID 8 in order to
>   conserve some space. Keep the bit positions intact because KVM requires
>   this. Reserve bits 0-7 for SGX in order to maintain this invariant also
>   when new SGX specific feature bits get added.
> 
> with
> 
>   Add the SGX sub-features in a new word even though only two bits will be
>   used in the immediate future.  KVM support for SGX is expected in the
>   not-too-distant future, and having a dedicated feature word allows KVM
>   to include SGX sub-features in its reserve-cpuid lookup table, e.g. to
>   easily query guest CPUID capabilities.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thank you. I merged this and added changelog entry.

/Jarkko
