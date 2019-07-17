Return-Path: <SRS0=+VJP=VO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9146CC7618F
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jul 2019 21:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70D0F21849
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jul 2019 21:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbfGQV5l (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Jul 2019 17:57:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:39448 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbfGQV5l (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Jul 2019 17:57:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 14:57:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,275,1559545200"; 
   d="scan'208";a="366708360"
Received: from bxing-desk.ccr.corp.intel.com (HELO [134.134.148.187]) ([134.134.148.187])
  by fmsmga005.fm.intel.com with ESMTP; 17 Jul 2019 14:57:39 -0700
Subject: Re: [RFC PATCH v4 3/3] selftests/x86/sgx: Augment SGX selftest to
 test vDSO API
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        kai.svahn@intel.com, kai.huang@intel.com
References: <cover.1563000446.git.cedric.xing@intel.com>
 <657fe13cbf962d72dc1afc0e25577d8e89225702.1563000446.git.cedric.xing@intel.com>
 <dddd9db0d2e7a4d4246ecbb096d0b35cd0aecb2a.camel@linux.intel.com>
 <6e53cf41-fb2a-0a08-22d0-e6bef2708f82@intel.com>
 <20190714144702.jzwrs6kanopv4227@linux.intel.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <52fc572e-c68e-9afd-251e-dc189440691c@intel.com>
Date:   Wed, 17 Jul 2019 14:57:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190714144702.jzwrs6kanopv4227@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/14/2019 7:47 AM, Jarkko Sakkinen wrote:
> On Sat, Jul 13, 2019 at 10:20:58AM -0700, Xing, Cedric wrote:
>> Like I said, there are plenty of test### functions in the selftests. And
>> your original version didn't have even a name - everything was inside main()
>> without any comments. How was your original version "reviewable"?
> 
> I don't care. We can do better than that.

Not that they did a poor job. You probably don't understand the 
intention here. Naming tests with numbers helps users correlate test 
outputs with test functions.

> If you have a specific thing that needs a comment in my selftest, please
> remark and I can add it.

You should have enclosed your test code in a function to be separated 
from the initialization code (e.g. finding vDSO in memory, locating API, 
etc.). My patch actually did that for you.

> As for your last question, I neither care about metaphysics. Please,
> stick to the content.

I tried to point out you are implementing a double standard here. Please 
do not misinterpret it.

> /Jarkko
> 
