Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08972C433FE
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Nov 2022 19:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiKPT04 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Nov 2022 14:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbiKPT0t (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 16 Nov 2022 14:26:49 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0736069E
        for <linux-sgx@vger.kernel.org>; Wed, 16 Nov 2022 11:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668626808; x=1700162808;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=+R5inw2znTkLvtmzm8kCpj0LQastHGWPq31Mth470S8=;
  b=VjHYf0jVrmBnzA2tRG+X791mtboi22FCUhcUhE5CEO3FXv1YRXmhrIDh
   JJ1d4ytqqmB6/9/7ep/B4RZ8f2uD5OrrEMsd5XLAeunVim80RQ7VbUgsl
   TDxgdllV6rLN6aMMFiyCmEm++/tSoUAAN5HJsOBADcBaMjRtpRvSJiw/K
   d6drrtAK/FJAI4PApQpJsn5pA/hWYUS/1Ljvn58svUzesX8SoThHTZK9K
   wRdVhI+wdv7jCmNqrFdk90Y8bYbX0beEwHUqtyoV8VvDAmxDZSSxen4kk
   XayYTOjqX29X3445A5L8L4e4cLZKFvAn0b0PBNQigMbDycKHBM+49Tu8o
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="398924840"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="398924840"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 11:26:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="968544342"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="968544342"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.122.136.145])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 16 Nov 2022 11:26:47 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Jarkko Sakkinen" <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com,
        reinette.chatre@intel.com, vijay.dhanraj@intel.com
Subject: Re: [RFC PATCH v3 3/4] selftests/sgx: add len field for EACCEPT op
References: <20221107220212.257422-1-haitao.huang@linux.intel.com>
 <20221107220212.257422-2-haitao.huang@linux.intel.com>
 <20221107220212.257422-3-haitao.huang@linux.intel.com>
 <20221107220212.257422-4-haitao.huang@linux.intel.com>
 <Y3QfrQFiWtOK3+c+@kernel.org>
Date:   Wed, 16 Nov 2022 13:26:46 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1vqqonrswjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <Y3QfrQFiWtOK3+c+@kernel.org>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 15 Nov 2022 17:24:29 -0600, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Mon, Nov 07, 2022 at 02:02:11PM -0800, Haitao Huang wrote:
>> So we can EACCEPT multiple pages inside enclave without EEXIT,
>> preparing for testing with MADV_WILLNEED for ranges bigger than
>> a single page.
>>
>> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>> ---
>>  tools/testing/selftests/sgx/defines.h   |  1 +
>>  tools/testing/selftests/sgx/test_encl.c | 20 ++++++++++++++------
>>  2 files changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/testing/selftests/sgx/defines.h  
>> b/tools/testing/selftests/sgx/defines.h
>> index d8587c971941..8578e773d3d8 100644
>> --- a/tools/testing/selftests/sgx/defines.h
>> +++ b/tools/testing/selftests/sgx/defines.h
>> @@ -60,6 +60,7 @@ struct encl_op_eaccept {
>>  	struct encl_op_header header;
>>  	uint64_t epc_addr;
>>  	uint64_t flags;
>> +	uint64_t len;
>>  	uint64_t ret;
>>  };
>>
>> diff --git a/tools/testing/selftests/sgx/test_encl.c  
>> b/tools/testing/selftests/sgx/test_encl.c
>> index c0d6397295e3..fc797385200b 100644
>> --- a/tools/testing/selftests/sgx/test_encl.c
>> +++ b/tools/testing/selftests/sgx/test_encl.c
>> @@ -35,14 +35,22 @@ static void do_encl_eaccept(void *_op)
>>  	struct sgx_secinfo secinfo __aligned(sizeof(struct sgx_secinfo)) =  
>> {0};
>>  	struct encl_op_eaccept *op = _op;
>>  	int rax;
>
> Should be empty line after declarations.
>
>> +	if (op->len == 0)
>> +		op->len = 4096;
>
> What is this?

Existing test cases is always eaccepting one page at a time.
With the new len field, this is to set value to 1 page by default so no  
changes in other places is needed.
I can add a comment in struct encl_op_eaccept declaration or let me know  
if you prefer a different way.

Thanks
Haitao
Haitao
