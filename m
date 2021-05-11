Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51003C433B4
	for <linux-sgx@archiver.kernel.org>; Tue, 11 May 2021 18:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039236191D
	for <linux-sgx@archiver.kernel.org>; Tue, 11 May 2021 18:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhEKSn7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 11 May 2021 14:43:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:32595 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhEKSn7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 11 May 2021 14:43:59 -0400
IronPort-SDR: zLRpky9fTDlIZUrkWZBo4I+/vViK8ZXZd9FZyVtAuH+4ElP+jUOeS7mUhanVX10Yckmfqkje2L
 e3vRUgClTbBg==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="199584267"
X-IronPort-AV: E=Sophos;i="5.82,291,1613462400"; 
   d="scan'208";a="199584267"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 11:42:50 -0700
IronPort-SDR: SNslpm6H7oY9Yy0CklaU2a5gXmehDeLljBthZO+XRQTzzmy/zNpYvxKwdFJtOB1sKFX2XwphPS
 Sm3Fe1AU2vnw==
X-IronPort-AV: E=Sophos;i="5.82,291,1613462400"; 
   d="scan'208";a="436794266"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.255.230.234]) ([10.255.230.234])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2021 11:42:50 -0700
Subject: Re: [PATCH v4 2/2] selftests/sgx: Migrate to kselftest harness
To:     Jarkko Sakkinen <jarkko@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210508035648.18176-1-jarkko@kernel.org>
 <20210508035648.18176-2-jarkko@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <960f1cd8-d805-8ed8-6af0-eed1f49e3c65@intel.com>
Date:   Tue, 11 May 2021 11:42:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508035648.18176-2-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/7/2021 8:56 PM, Jarkko Sakkinen wrote:
> Migrate to kselftest harness. Use a fixture test with enclave initialized
> and de-initialized for each of the existing three tests, in other words:
> 
> 1. One FIXTURE() for managing the enclave life-cycle.
> 2. Three TEST_F()'s, one for each test case.

These changes make it easier to add tests and I think it is a valuable 
addition.

> 
> This gives a leaps better reporting than before. Here's an example
> transcript:
> 
> TAP version 13
> 1..3
> 0x0000000000000000 0x0000000000002000 0x03
> 0x0000000000002000 0x0000000000001000 0x05
> 0x0000000000003000 0x0000000000003000 0x03
> ok 1 enclave.unclobbered_vdso
> 0x0000000000000000 0x0000000000002000 0x03
> 0x0000000000002000 0x0000000000001000 0x05
> 0x0000000000003000 0x0000000000003000 0x03
> ok 2 enclave.clobbered_vdso
> 0x0000000000000000 0x0000000000002000 0x03
> 0x0000000000002000 0x0000000000001000 0x05
> 0x0000000000003000 0x0000000000003000 0x03
> ok 3 enclave.clobbered_vdso_and_user_function
> 

The output claims to conform to TAP13 but it does not seem as though all 
of the output conforms to TAP13. I assume such output would confuse 
automated systems.

Reinette
