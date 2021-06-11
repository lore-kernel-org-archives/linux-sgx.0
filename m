Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD220C48BD1
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jun 2021 22:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9597F613F0
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Jun 2021 22:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFKWrg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Jun 2021 18:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFKWrg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 11 Jun 2021 18:47:36 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21584C0613A2
        for <linux-sgx@vger.kernel.org>; Fri, 11 Jun 2021 15:45:22 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id b25so32791722iot.5
        for <linux-sgx@vger.kernel.org>; Fri, 11 Jun 2021 15:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xXgtc2a812WbOwUgteqiwpKHqvHn2zU6NCj+s0gCiUg=;
        b=c0SIGJ88ohLjl2HfT/CDCCzhoHvhw3vQcijzfAgxaGj3ziLqY98ylpNEdwyi4ZYiIy
         AN0qrHAWRuW/XwqBAmfWqM0qvIxmluzT2W36dx5Mc6WfXpe73C7CvoHRAhx2UDdMCTc1
         OW5UVN805paBVZcr5p3G5s+etr34liykK6wbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xXgtc2a812WbOwUgteqiwpKHqvHn2zU6NCj+s0gCiUg=;
        b=iNiWLh4+720SzrQnlPhAvm9nL0a9pKm+tL0VQ1wmBCgSPSMt/aTi6zxIZE/YlnwS0c
         oQ7PbJPvBmAmZmjZyfq4JxP4MVt6Q5s4pgAQiaewodKUunmtNPfHEb9cPiGBviw3jUNd
         mCgE9b/a4804AuxAGp8AIIpcXRMIcTXYNulxww2Dv7QKIt1HgCc2KXrUx/6cRn/IiJnS
         IZnmB3QOOlIjwtS3Um7caX9R+Ey5ACzeuIEiweFyeuFafbNEEl+JcUYSgpVEJHQLSypY
         RHmvisypDkQtN9zSjSRC0VkCmPygUxr4fUJlEX9nii79iGft4kXEI2yNyE5Z0+KJ6bGc
         jVRQ==
X-Gm-Message-State: AOAM532yLFzioPXnYT261a+F63gcer0cZzUthTMm3+Plt8+2nRBG6GUr
        BPt0vx+VuxKSqGmSBVVnmyxDhQ==
X-Google-Smtp-Source: ABdhPJxJJIF6snEw4w1Ne6eoIiotz2QkFrb9tZBQiqNlnwUb9VM1XLwMIR49Ra7s9SAVqwiRp7eYyw==
X-Received: by 2002:a05:6602:1234:: with SMTP id z20mr5007745iot.167.1623451521393;
        Fri, 11 Jun 2021 15:45:21 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id q23sm4416936ior.46.2021.06.11.15.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 15:45:20 -0700 (PDT)
Subject: Re: [PATCH v8 3/5] selftests/sgx: Dump enclave memory map
To:     Jarkko Sakkinen <jarkko@kernel.org>, shuah@kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210610083021.392269-1-jarkko@kernel.org>
 <20210610083021.392269-3-jarkko@kernel.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <bb39b6af-5921-64e8-793b-5ef4b150153e@linuxfoundation.org>
Date:   Fri, 11 Jun 2021 16:45:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210610083021.392269-3-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 6/10/21 2:30 AM, Jarkko Sakkinen wrote:
> Often, it's useful to check whether /proc/self/maps looks sane when
> dealing with memory mapped objects, especially when they are JIT'ish
> dynamically constructed objects. Therefore, dump "/dev/sgx_enclave"
> matching lines from the memory map in FIXTURE_SETUP().
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>   tools/testing/selftests/sgx/main.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
> index 6da19b6bf287..14030f8b85ff 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -117,6 +117,8 @@ FIXTURE_SETUP(enclave)
>   	Elf64_Sym *sgx_enter_enclave_sym = NULL;
>   	struct vdso_symtab symtab;
>   	struct encl_segment *seg;
> +	char maps_line[256];
> +	FILE *maps_file;
>   	unsigned int i;
>   	void *addr;
>   
> @@ -167,6 +169,18 @@ FIXTURE_SETUP(enclave)
>   	memset(&self->run, 0, sizeof(self->run));
>   	self->run.tcs = self->encl.encl_base;
>   
> +	maps_file = fopen("/proc/self/maps", "r");

I almost applied these. Does this require root access, if so,
please add logic to skip the test if non-root user runs it.

Same comments for all other paths that might require root access.

thanks,
-- Shuah
