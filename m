Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2B5C43331
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 19:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C37A2072E
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 19:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgC3TTw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 15:19:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:19442 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbgC3TTv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 15:19:51 -0400
IronPort-SDR: THvI+k8jrysnoR+3lkiH2ro1NMYCkZuSYbTU9cKdr2emumPxJUxlAWJX131Jcw9+DpI5DEGYC2
 X74bE1l641SQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 12:19:51 -0700
IronPort-SDR: IQTL6fy/NFxCC8PeenXGM/kPJY1u89We4J5XBP8HSHLW4XlnzibE9gZn8yHm1uX1PQvSKzBjt8
 lWcui/yUKpKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="272473412"
Received: from plachner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.35.129])
  by fmsmga004.fm.intel.com with ESMTP; 30 Mar 2020 12:19:49 -0700
Date:   Mon, 30 Mar 2020 22:19:48 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests/x86/sgx: Move to selftests/sgx
Message-ID: <20200330191948.GB1384380@linux.intel.com>
References: <20200320174716.27944-1-jarkko.sakkinen@linux.intel.com>
 <20200320174716.27944-2-jarkko.sakkinen@linux.intel.com>
 <20200330145101.GB24988@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330145101.GB24988@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 30, 2020 at 07:51:01AM -0700, Sean Christopherson wrote:
> The scope of the subject for the selftest patch probably should be changed
> to drop the "x86" part, e.g.
> 
>   selftests/sgx: Add a selftest for SGX
> 
> or
>   selftests: Add a selftest for SGX
> 
> instead of
> 
>   selftests/x86: Add a selftest for SGX

You are absolutely right as it is the change that adds the whole test
suite.

/Jarkko
