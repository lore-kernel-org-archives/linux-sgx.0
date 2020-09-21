Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24ED3C4363C
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 21:26:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D544123A5F
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 21:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgIUV0r (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 17:26:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:27497 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgIUV0r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 17:26:47 -0400
IronPort-SDR: td84sAxeDzTxHcb/38PT2hEV4d94fiOp5+NT3mLkqFn8kiFzwddddwNN+bJdy8t0RnK9td0haI
 IX/Lt0fCT8WA==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="148236530"
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="148236530"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 14:26:46 -0700
IronPort-SDR: 8hTzxnHAWYHcALgtM6rYikOTI+yHRcM5M8fwXePA/kS0QmDiDwK/qbnrk83Lzd2gwyKPbLEKdp
 VkZTjrJzvgXQ==
X-IronPort-AV: E=Sophos;i="5.77,288,1596524400"; 
   d="scan'208";a="485671677"
Received: from kofels-mobl.ger.corp.intel.com (HELO localhost) ([10.249.45.179])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 14:26:40 -0700
Date:   Tue, 22 Sep 2020 00:26:38 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v38 15/24] x86/sgx: Enable provisioning for remote
 attestation
Message-ID: <20200921212638.GB59547@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-16-jarkko.sakkinen@linux.intel.com>
 <20200921180728.GJ5901@zn.tnic>
 <20200921192706.GD53597@linux.intel.com>
 <20200921194156.GM5901@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921194156.GM5901@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 09:41:56PM +0200, Borislav Petkov wrote:
> On Mon, Sep 21, 2020 at 10:27:06PM +0300, Jarkko Sakkinen wrote:
> > 'sgx_dev_enclave' is successfully register whenever that happens. Am I
> > missing something here?
> 
> No, I was missing the fact that you have *two* misc devices and you're
> deregistering the first one in the error path of the second.
> 
> Forget what I said. ;-\

Ok, great.

BTW, probably would make sense to rewrite the short summary as:

"x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION"

for the sake of consistency with the three precursoring patches.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
