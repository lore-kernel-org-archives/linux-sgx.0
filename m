Return-Path: <SRS0=TOMN=VH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DD1C74A35
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 18:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 615A9208C4
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Jul 2019 18:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfGJSQK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Jul 2019 14:16:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:16034 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbfGJSQJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 10 Jul 2019 14:16:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 11:16:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,475,1557212400"; 
   d="scan'208";a="365016610"
Received: from bxing-mobl.amr.corp.intel.com (HELO [10.255.93.70]) ([10.255.93.70])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jul 2019 11:16:08 -0700
Subject: Re: [RFC PATCH v3 4/4] x86/sgx: Implement SGX specific hooks in
 SELinux
To:     Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
 <3a9efc8d3c27490dbcfe802ce3facddd62f47872.1562542383.git.cedric.xing@intel.com>
 <20190710154915.GA4331@linux.intel.com>
 <d6506d52-2da6-7667-aae4-e3eef7596e93@fortanix.com>
From:   "Xing, Cedric" <cedric.xing@intel.com>
Message-ID: <f0ed568f-9fd6-1c86-6eee-0fa8f5d0b811@intel.com>
Date:   Wed, 10 Jul 2019 11:16:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d6506d52-2da6-7667-aae4-e3eef7596e93@fortanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/10/2019 9:08 AM, Jethro Beekman wrote:
> On 2019-07-10 08:49, Sean Christopherson wrote:
>> On Sun, Jul 07, 2019 at 04:41:34PM -0700, Cedric Xing wrote:
>>> selinux_enclave_init() determines if an enclave is allowed to launch, 
>>> using the
>>> criteria described earlier. This implementation does NOT accept 
>>> SIGSTRUCT in
>>> anonymous memory. The backing file is also cached in struct
>>> file_security_struct and will serve as the base for decisions for 
>>> anonymous
>>> pages.
>>
>> Did we ever reach a consensus on whether sigstruct must reside in a file?
> 
> This would be inconvenient for me, but I guess I can create a memfd?

No, sigstruct doesn't have to reside in a file.

But the current direction is, in SELinux, what the enclave can do 
depends on permissions given to the file containing sigstruct. That 
said, if SELinux is in effect, sigstruct has to reside in a real file 
with FILE__EXECUTE permission for the enclave to launch. memfd wouldn't 
work. To some extent, that serves the purpose of whitelisting.

> -- 
> Jethro Beekman | Fortanix
> 
