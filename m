Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E82C47082
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Jun 2021 16:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F21D861D09
	for <linux-sgx@archiver.kernel.org>; Mon,  7 Jun 2021 16:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhFGQfO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 7 Jun 2021 12:35:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:5142 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhFGQbi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 7 Jun 2021 12:31:38 -0400
IronPort-SDR: yOTthFWS7K5gJIsFvQfv33xSIfJtrgZjRdRFDcCD9507A41fr0MvouOsObzZxMulHn6WDDT3aF
 VLbrXtzbnzdQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="202794891"
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="202794891"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:28:58 -0700
IronPort-SDR: IIx69deURibCY4UJEWJuWLPvOXIOmcN8wADPJOV5FYROvnJ/DLyDXtMpHIdkfNwTzBByVgYyIE
 Rh9Us1Yjd5bw==
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="637327808"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.209.69.116]) ([10.209.69.116])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2021 09:28:57 -0700
Subject: Re: [PATCH v7 1/4] selftests/sgx: Rename 'eenter' and 'sgx_call_vdso'
To:     Jarkko Sakkinen <jarkko@kernel.org>, shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <20210526124740.16783-1-jarkko@kernel.org>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <dddeda6a-0f76-8e5a-6ca8-2ad67f6411ea@intel.com>
Date:   Mon, 7 Jun 2021 09:28:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210526124740.16783-1-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Jarkko,

On 5/26/2021 5:47 AM, Jarkko Sakkinen wrote:
> diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
> index 67211a708f04..68672fd86cf9 100644
> --- a/tools/testing/selftests/sgx/main.h
> +++ b/tools/testing/selftests/sgx/main.h
> @@ -35,7 +35,7 @@ bool encl_load(const char *path, struct encl *encl);
>   bool encl_measure(struct encl *encl);
>   bool encl_build(struct encl *encl);
>   
> -int sgx_call_vdso(void *rdi, void *rsi, long rdx, u32 function, void *r8, void *r9,
> -		  struct sgx_enclave_run *run);
> +int sgx_enter_enclave(void *rdi, void *rsi, long rdx, u32 function, void *r8, void *r9,
> +		      struct sgx_enclave_run *run);
>   

Is there a reason why all registers except rdx are "void *"?

Reinette
