Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2648BC77B75
	for <linux-sgx@archiver.kernel.org>; Mon,  8 May 2023 17:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbjEHRBw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 May 2023 13:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjEHRBv (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 8 May 2023 13:01:51 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9854249C8
        for <linux-sgx@vger.kernel.org>; Mon,  8 May 2023 10:01:50 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-763970c9a9eso15752039f.1
        for <linux-sgx@vger.kernel.org>; Mon, 08 May 2023 10:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683565310; x=1686157310;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uGkkepj9uIdDICMrxMndUulUvecqVCgR4rzaumC4TR4=;
        b=NsfnKeTWD/dyy+Vv4GYVh6EgWJb1I4xeUJFMzOIzq3y7cFVqS4ha8TvttIiye4Nyr3
         WdTpM1RIhcJ+zpDrAw1EQ0pGum6SO8WvcOg6fi3gM7td4g8AvF/NwY693JJUztXcHK6/
         U2NujO+k5PrYREi2hV921EJ/o1nJe2TrzST9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683565310; x=1686157310;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uGkkepj9uIdDICMrxMndUulUvecqVCgR4rzaumC4TR4=;
        b=UBMWpvwV7KpJ+UPHDaw8Orir7VQvn18zrkwIKIQSSYfedQSUlbgqgLxFn4flNbv5Ai
         +w2IiEhYkEnaWVwrJVQZNMiRtWYL1V5JyC3Zo+45s2j7U5OV9Y0ssuQtQJxSYDFPA5EO
         r+ktqt9XMCmPv/URyNzcYZB8fz0RBtXdtiBwiCkstluPif7TzQmpVJznvXCeoTOZCsQK
         7YLwVDBPWHorV0VK4IokABTYsjml18NclsFPo6zAszGbqxsQBzQY31o8ejY28ydraX3t
         xZbkca86Sc3PPs5X96cCNgE1DvTo6ca0seMQvajr6RR6uOcQoUy0f4T0Ug6JLA/aV8Om
         qXbw==
X-Gm-Message-State: AC+VfDw/O8pcRa/rbrURWqIpmFf+2G3Ru6+uwFfH/N4ezhI4z/VWSvc4
        Uk02NHLDKovfxBHKD2LEpezphA==
X-Google-Smtp-Source: ACHHUZ6jVUf/GP5+8HvKeWtAVlZngdDEaPyLPQzXAJ+T4LtB5UhxLCBKBfTRa1t99uZiyw8f/K4bMQ==
X-Received: by 2002:a6b:5f09:0:b0:760:f7e4:7941 with SMTP id t9-20020a6b5f09000000b00760f7e47941mr5308383iob.0.1683565309907;
        Mon, 08 May 2023 10:01:49 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z12-20020a5ec90c000000b007635e28bc11sm2324584iol.6.2023.05.08.10.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 10:01:49 -0700 (PDT)
Message-ID: <ab721d9a-5209-d961-6eb7-38f5b6272a60@linuxfoundation.org>
Date:   Mon, 8 May 2023 11:01:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RESEND PATCH] selftests/sgx: Add "test_encl.elf" to TEST_FILES
Content-Language: en-US
To:     Yi Lai <yi1.lai@intel.com>, jarkko@kernel.org,
        dave.hansen@linux.intel.com, shuah@kernel.org, jethro@fortanix.com,
        bp@suse.de
Cc:     linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        heng.su@intel.com, pengfei.xu@intel.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230421033123.445883-1-yi1.lai@intel.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230421033123.445883-1-yi1.lai@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 4/20/23 21:31, Yi Lai wrote:
> The "test_encl.elf" file used by test_sgx is not installed in
> INSTALL_PATH. Attempting to execute test_sgx causes false negative:
> 
> "
> enclave executable open(): No such file or directory
> main.c:188:unclobbered_vdso:Failed to load the test enclave.
> "
> 
> Add "test_encl.elf" to TEST_FILES so that it will be installed.
> 
> Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
> Signed-off-by: Yi Lai <yi1.lai@intel.com>

Applied now to linux-kselftest fixes for the next rc.

Thank for your the fix.

thanks,
-- Shuah

