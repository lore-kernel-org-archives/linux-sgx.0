Return-Path: <SRS0=VoGi=VL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB3CC73C66
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Jul 2019 14:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D12205F4
	for <linux-sgx@archiver.kernel.org>; Sun, 14 Jul 2019 14:47:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbfGNOre (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 14 Jul 2019 10:47:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:34105 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbfGNOre (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 14 Jul 2019 10:47:34 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jul 2019 07:47:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,490,1557212400"; 
   d="scan'208";a="172006173"
Received: from hgenzken-mobl.ger.corp.intel.com (HELO localhost) ([10.249.35.131])
  by orsmga006.jf.intel.com with ESMTP; 14 Jul 2019 07:47:03 -0700
Date:   Sun, 14 Jul 2019 17:47:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
Subject: Re: [RFC PATCH v4 3/3] selftests/x86/sgx: Augment SGX selftest to
 test vDSO API
Message-ID: <20190714144702.jzwrs6kanopv4227@linux.intel.com>
References: <cover.1563000446.git.cedric.xing@intel.com>
 <657fe13cbf962d72dc1afc0e25577d8e89225702.1563000446.git.cedric.xing@intel.com>
 <dddd9db0d2e7a4d4246ecbb096d0b35cd0aecb2a.camel@linux.intel.com>
 <6e53cf41-fb2a-0a08-22d0-e6bef2708f82@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e53cf41-fb2a-0a08-22d0-e6bef2708f82@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Jul 13, 2019 at 10:20:58AM -0700, Xing, Cedric wrote:
> Like I said, there are plenty of test### functions in the selftests. And
> your original version didn't have even a name - everything was inside main()
> without any comments. How was your original version "reviewable"?

I don't care. We can do better than that.

If you have a specific thing that needs a comment in my selftest, please
remark and I can add it.

As for your last question, I neither care about metaphysics. Please,
stick to the content.

/Jarkko
