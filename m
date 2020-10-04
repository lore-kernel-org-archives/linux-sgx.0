Return-Path: <SRS0=pKip=DL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5266CC4363D
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 15:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075F8206C1
	for <linux-sgx@archiver.kernel.org>; Sun,  4 Oct 2020 15:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgJDPCB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 11:02:01 -0400
Received: from mga17.intel.com ([192.55.52.151]:50321 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgJDPCB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 11:02:01 -0400
IronPort-SDR: UQE0i3RkS8K8CFHfp/+MBCeK1qmlJ4pBHHHjtE/LgAWYMLO4yWYQA7UqUaSQ+vw9b5vtw3H39J
 IlSttlXq5ZhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="143282282"
X-IronPort-AV: E=Sophos;i="5.77,335,1596524400"; 
   d="scan'208";a="143282282"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 08:02:00 -0700
IronPort-SDR: lVbISDCbwHZWaA6CGV7R/T+rD3JJF9kTGccXpgVMmzhqbqAKn2yKW+b7n+fnhDvfT/JbscwgJ1
 4UCSICzZME6Q==
X-IronPort-AV: E=Sophos;i="5.77,335,1596524400"; 
   d="scan'208";a="516451559"
Received: from pkozlov-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.35.250])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 08:01:53 -0700
Date:   Sun, 4 Oct 2020 18:01:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        mikko.ylinen@intel.com
Subject: Re: [PATCH v39 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20201004150151.GC3561@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-12-jarkko.sakkinen@linux.intel.com>
 <20201003143925.GB800720@kroah.com>
 <20201004143246.GA3561@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004143246.GA3561@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Oct 04, 2020 at 05:32:57PM +0300, Jarkko Sakkinen wrote:
> On Sat, Oct 03, 2020 at 04:39:25PM +0200, Greg KH wrote:
> > You use gpl-only header files in this file, so how in the world can it
> > be bsd-3 licensed?
> > 
> > Please get your legal department to agree with this, after you explain
> > to them how you are mixing gpl2-only code in with this file.
> 
> I'll do what I already stated that I will do. Should I do something
> more?

And forward this message to the aformentioned entity.

/Jarkko
