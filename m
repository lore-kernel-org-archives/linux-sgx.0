Return-Path: <SRS0=03YQ=C6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059C4C43463
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 12:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB895216C4
	for <linux-sgx@archiver.kernel.org>; Mon, 21 Sep 2020 12:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIUMJx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 21 Sep 2020 08:09:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:16720 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgIUMJx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 21 Sep 2020 08:09:53 -0400
IronPort-SDR: ehrw21HfK/ra5JmkDJApEhhJN/E1J4A5m0mROpKnNYYBcz7FF/5KXztQUQN/rf72W5CI75+WTM
 0e9Y9gNWZ47g==
X-IronPort-AV: E=McAfee;i="6000,8403,9750"; a="160418853"
X-IronPort-AV: E=Sophos;i="5.77,286,1596524400"; 
   d="scan'208";a="160418853"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 05:09:50 -0700
IronPort-SDR: i4aQg6HRak9Wwf1lg8floO6KC3eH7WhhL8EtMWe0QOURWl3xKjzy8eEMNKgcVkz6R++XTai8CI
 bxzbLgbhY7Ew==
X-IronPort-AV: E=Sophos;i="5.77,286,1596524400"; 
   d="scan'208";a="485417121"
Received: from clairemo-mobl.ger.corp.intel.com (HELO localhost) ([10.252.43.50])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 05:09:42 -0700
Date:   Mon, 21 Sep 2020 15:09:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
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
        andriy.shevchenko@linux.intel.com, asapek@google.com,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v38 11/24] x86/sgx: Add SGX enclave driver
Message-ID: <20200921120939.GD6038@linux.intel.com>
References: <20200915112842.897265-1-jarkko.sakkinen@linux.intel.com>
 <20200915112842.897265-12-jarkko.sakkinen@linux.intel.com>
 <20200921093006.GA5901@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921093006.GA5901@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Sep 21, 2020 at 11:30:06AM +0200, Borislav Petkov wrote:
> On Tue, Sep 15, 2020 at 02:28:29PM +0300, Jarkko Sakkinen wrote:
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that can
> > be used by applications to set aside private regions of code and data. The
> > code outside the SGX hosted software entity is prevented from accessing the
> > memory inside the enclave by the CPU. We call these entities as enclaves.
> 
> It was correct before:
> 
> -memory inside the enclave by the CPU. We call these entities enclaves.
> +memory inside the enclave by the CPU. We call these entities as enclaves.
> 
> "as " is not needed.

I reworded it. Thank you.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

/Jarkko
