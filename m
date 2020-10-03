Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04743C41604
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 14:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1FB206C3
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 14:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgJCOx1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 10:53:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:63951 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgJCOx1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 10:53:27 -0400
IronPort-SDR: NPUNfHE8P3RjkqfYRPRfIamtGXOxJlOxKAEZDCm6hKKvhQ5dxFS8C/eGUfDjkKziU17+EMpwfA
 xaPmLVwpTXmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9763"; a="224833200"
X-IronPort-AV: E=Sophos;i="5.77,331,1596524400"; 
   d="scan'208";a="224833200"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2020 07:53:25 -0700
IronPort-SDR: Nxgr6J7zaLUrN/rYIYW/Qini8HVbXOdOMbCKb1U9ZXZUMYtfU4pqevBJ4F4NUSLcV/hHRRvs+T
 j6TsPan8u1hg==
X-IronPort-AV: E=Sophos;i="5.77,331,1596524400"; 
   d="scan'208";a="514593364"
Received: from kboulton-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.33.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2020 07:53:11 -0700
Date:   Sat, 3 Oct 2020 17:53:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 00/24] Intel SGX foundations
Message-ID: <20201003145307.GA7719@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003143246.GA800720@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201003143246.GA800720@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 03, 2020 at 04:32:46PM +0200, Greg KH wrote:
> I might be late to the game, but why are you trying to dual-license the
> new files you are adding in this patch?  How will that help anyone?
> 
> I have had many talks with Intel about this in the past, and last I
> heard was that when dual-licensing made sense, they would be explicit as
> to why it was happening.  Or is my memory failing me?

My true and honest answer is that I cannot recall. Not sure even if it
was like when the driver was still out-of-tree implementation. This
would back to 2016 :-)

But we don't need to dig the exact answr because

➜  linux-tpmdd (next) ✔ git --no-pager grep -e BSD --and \( -e SPDX \)  -- "arch/*.[Sc]"
arch/arm64/lib/tishift.S:/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)

Oh darn, I guess this implies that my hands are tied :-) I'll gladly
implement the change.

> thanks,
> 
> greg k-h

Thank you.

/Jarkko
