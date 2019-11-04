Return-Path: <SRS0=L1tv=Y4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E946CA9EC9
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 22:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A1412084D
	for <linux-sgx@archiver.kernel.org>; Mon,  4 Nov 2019 22:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfKDWhv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 17:37:51 -0500
Received: from mga06.intel.com ([134.134.136.31]:38715 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728940AbfKDWhv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 17:37:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 14:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="401774708"
Received: from rczubala-mobl.ger.corp.intel.com (HELO localhost) ([10.252.7.245])
  by fmsmga005.fm.intel.com with ESMTP; 04 Nov 2019 14:37:49 -0800
Date:   Tue, 5 Nov 2019 00:37:41 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 3/3] x86/sgx: Remove a subordinate clause
Message-ID: <20191104223741.GD3606@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
 <20191104200141.5385-3-jarkko.sakkinen@linux.intel.com>
 <20191104212122.GC5960@linux.intel.com>
 <20191104223636.GC3606@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104223636.GC3606@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 05, 2019 at 12:36:59AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 04, 2019 at 01:21:22PM -0800, Sean Christopherson wrote:
> > On Mon, Nov 04, 2019 at 10:01:41PM +0200, Jarkko Sakkinen wrote:
> > > The subordinate clause of last sentence of the sgx_ioc_enclave_pages()
> > > does not provide any insight not already provided. Thus, remove it.
> > 
> > Isn't the whole point of the documentation to help the user understand
> > *how* to use the API, not simply state exactly what the code does?
> 
> For kdoc it should explain in clear and concise way

... what the function does.

/Jarkko
