Return-Path: <SRS0=RM8m=AG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC419C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 22:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA9420767
	for <linux-sgx@archiver.kernel.org>; Thu, 25 Jun 2020 22:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406500AbgFYW06 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 25 Jun 2020 18:26:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:53997 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403905AbgFYW06 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 25 Jun 2020 18:26:58 -0400
IronPort-SDR: CSMZOrRMrY9tL1XyD5yRmcoRi5QpGZbQP0CbG7TOCwjDsYxL+k6S5JAMn2fy23nmF4Poj9r/Ow
 3Rh+Pzv8mcoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="124748794"
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="124748794"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 15:26:57 -0700
IronPort-SDR: njrzfzUtC8+nKGs2G/NpEGTxfFgOHOL5/y/dxmYAdoTlhAZQdS5hDwd7PXU8vh3BpEittZ6s/v
 aH6Qpljz7c0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,280,1589266800"; 
   d="scan'208";a="276176831"
Received: from jproldan-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.123])
  by orsmga003.jf.intel.com with ESMTP; 25 Jun 2020 15:26:46 -0700
Date:   Fri, 26 Jun 2020 01:26:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH v33 10/21] mm: Introduce vm_ops->may_mprotect()
Message-ID: <20200625222645.GK20341@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-11-jarkko.sakkinen@linux.intel.com>
 <20200625171416.GI20319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625171416.GI20319@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 25, 2020 at 07:14:16PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:32AM +0300, Jarkko Sakkinen wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Add vm_ops()->may_mprotect() to check additional constraints.
> > 
> > SGX uses this callback to add two constraints:
> > 
> > 1. Verify that the address range does not have holes: for each page
> >    address, there is an actual enclave page created.
> > 2. Mapped permissions do not surpass the lowest enclave page permissions
> >    in the address range.
> > 
> > linux-mm@kvack.org
> > Andrew Morton <akpm@linux-foundation.org>
> 
> Something ate the Cc:s. Lemme add the mm list, akpm is already on Cc.
> 
> Leaving in the rest for mm folks.

Thank you. So it seems. I've fixed them now.

/Jarkko
