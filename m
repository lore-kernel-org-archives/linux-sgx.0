Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB370C3A59E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 05:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE8A421848
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 05:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfHZF7i (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 01:59:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:34482 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbfHZF7i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 01:59:38 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Aug 2019 22:59:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="209244309"
Received: from chlopez-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.177])
  by fmsmga002.fm.intel.com with ESMTP; 25 Aug 2019 22:59:35 -0700
Date:   Mon, 26 Aug 2019 08:59:34 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Serge Ayoun <serge.ayoun@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sean Christoherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix sgx_ioc_enclave_add_page() documentation
Message-ID: <20190826055934.cb6gsvueoe4jife3@linux.intel.com>
References: <20190826053248.4403-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826053248.4403-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Aug 26, 2019 at 08:32:48AM +0300, Jarkko Sakkinen wrote:
> Refine the kdoc of sgx_ioc_enclave_add_page() with a proper description
> about the interaction with mmap(). Without documentation, it is
> impossible to review the code change.
> 
> Cc: Serge Ayoun <serge.ayoun@intel.com>
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Cc: Sean Christoherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

I squashed this.

/Jarkko
