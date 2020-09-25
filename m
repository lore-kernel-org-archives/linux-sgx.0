Return-Path: <SRS0=dOd4=DC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A01FC4363D
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2103821D91
	for <linux-sgx@archiver.kernel.org>; Fri, 25 Sep 2020 11:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbgIYLAh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 25 Sep 2020 07:00:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:55003 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727402AbgIYLAh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 25 Sep 2020 07:00:37 -0400
IronPort-SDR: c99qNP3mrz4w6DYAcKWMSg1N1X8UM8/Ujb4yqXO4onauyGCy9JDg/oI8ZSqVBmjYAwya7Xqcou
 iK3E4t5b9U/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="158846068"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="158846068"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:00:37 -0700
IronPort-SDR: 6/QwGSb55DvHkqbLuAcYtfDExzrdROMhipGG+B2MoEoLS7mAdi0X2dPRglSdtJbwj1MwqXw1T1
 31wcogW6ioiw==
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="455785078"
Received: from tjhenson-mobl.amr.corp.intel.com (HELO localhost) ([10.252.48.117])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 04:00:30 -0700
Date:   Fri, 25 Sep 2020 14:00:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 17/24] x86/sgx: ptrace() support for the SGX driver'
Message-ID: <20200925110028.GC180915@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-18-jarkko.sakkinen@linux.intel.com>
 <20200922154424.GL22660@zn.tnic>
 <20200923132037.GA5160@linux.intel.com>
 <20200923161733.GP28545@zn.tnic>
 <20200924115119.GD56811@linux.intel.com>
 <20200924155751.GJ5030@zn.tnic>
 <20200924203859.GD108958@linux.intel.com>
 <20200924204022.GE108958@linux.intel.com>
 <20200925075301.GE16872@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925075301.GE16872@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 09:53:01AM +0200, Borislav Petkov wrote:
> On Thu, Sep 24, 2020 at 11:40:22PM +0300, Jarkko Sakkinen wrote:
> > I'm not sure if I said it already but I also added cc to linux-mm (same
> > CC's in the patch as with mprotect callback commit). This should also
> > have mm ack I think.
> 
> Why? This is adding ptrace functionality to enclaves which is purely
> arch/x86/.

You are right. No changes to vm_operations_struct itself.

> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
