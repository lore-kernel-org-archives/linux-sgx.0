Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B69C433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8E0020722
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgGGEq2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jul 2020 00:46:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:25277 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbgGGEq1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Jul 2020 00:46:27 -0400
IronPort-SDR: S92ZUWu7XgTteUrdwK5CKYaOhuadAtgJnah22YuhyvTcZSSjSSlEi2HVJI9jVqJy6Y5A7i3UbR
 ZXInuMfroRoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="135003756"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="135003756"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 21:46:26 -0700
IronPort-SDR: w1b9Him4wF924ynVOVfX3FzeCVWWZZd2W8yiIgjwYBmic5wh/uZEBbDVcQfs9t3XfDpcfurZCp
 U0yapIVw6r2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="456970927"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga005.jf.intel.com with ESMTP; 06 Jul 2020 21:46:26 -0700
Date:   Mon, 6 Jul 2020 21:46:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v34 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20200707044626.GE5208@linux.intel.com>
References: <20200707030204.126021-1-jarkko.sakkinen@linux.intel.com>
 <20200707030204.126021-12-jarkko.sakkinen@linux.intel.com>
 <20200707033617.GF25523@casper.infradead.org>
 <20200707041151.GE143804@linux.intel.com>
 <20200707042904.GD5208@linux.intel.com>
 <20200707043904.GJ25523@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707043904.GJ25523@casper.infradead.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 05:39:04AM +0100, Matthew Wilcox wrote:
> although I think you have a simpler task.
> 
> 	XA_STATE(xas, ..., start_index);
> 
> 	for (;;) {
> 		struct page *page = xas_next(&xas);
> 
> 		if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> 			return -EACCES;
> 	}
> 
> 	return 0;
> 
> should do the trick, I think.

Ah, neato.  Thanks!
