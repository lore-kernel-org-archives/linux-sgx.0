Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D58EB64DA
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jul 2023 19:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjGTTea (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jul 2023 15:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjGTTe2 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 20 Jul 2023 15:34:28 -0400
Received: from icts-p-cavuit-1.kulnet.kuleuven.be (icts-p-cavuit-1.kulnet.kuleuven.be [IPv6:2a02:2c40:0:c0::25:132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E952D41;
        Thu, 20 Jul 2023 12:34:24 -0700 (PDT)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: EB0A620162.AA96D
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-1.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:136:242:ac11:f])
        by icts-p-cavuit-1.kulnet.kuleuven.be (Postfix) with ESMTP id EB0A620162;
        Thu, 20 Jul 2023 21:34:20 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID#0.00,SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_SIGNED#0.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1689881660;
        bh=lE/1SCk3jwIOo+hWTMX1BDV5X7rAEeBq8ZAhHriZSi0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=Tza6NCKmPCTmayVmxBkrtlJWVWqE/mJfRoe2yRJh8RwGyE/iv/n9/Ug2sqGMHrQqg
         QRKdGYbeIGk539VppDd65vqEwvBolUTZehEUJDH1nD4wGV1U+r7JVTUOoY2XAgAPXp
         /wAppV+q35oIPPZr8ONqbZj70Np74LbUuJUD0U4o=
Received: from [IPV6:2a02:1210:6c17:f000:af2b:c1b5:c15b:acda] (unknown [IPv6:2a02:1210:6c17:f000:af2b:c1b5:c15b:acda])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by icts-p-ceifnet-smtps-1.kuleuven.be (Postfix) with ESMTPSA id 9FAA3D4E6B4BA;
        Thu, 20 Jul 2023 21:34:20 +0200 (CEST)
Message-ID: <a1bd8864-a7df-9fc8-8257-bfc0d3620c22@cs.kuleuven.be>
Date:   Thu, 20 Jul 2023 21:34:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/4] selftests/sgx: Harden test enclave API
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@linux.intel.com
References: <20230719142500.13623-1-jo.vanbulck@cs.kuleuven.be>
 <20230719142500.13623-4-jo.vanbulck@cs.kuleuven.be>
 <CU76GKAGAGRG.22Y5TDTJ86WJR@suppilovahvero>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <CU76GKAGAGRG.22Y5TDTJ86WJR@suppilovahvero>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 20.07.23 19:32, Jarkko Sakkinen wrote:

>> +#define PANIC()								\
>> +	asm("ud2\n\t")
> 
> any reason not to use static inline function?
>

Thanks for the suggestion, no reason in this case. Apart perhaps that 
it's only 1 line of code and an inline function may seem a bit like a 
waste (given that gcc does not inline until certain optimization 
levels). I can surely change it to static inline void panic(void) if you 
prefer?

>> +#define SAFE_COPY_STRUCT(u_arg, t_cp)					\ >> +	do {								\
>> +		/* 1. check if the argument lies entirely outside */	\
>> +		if (!is_outside_enclave((void *)u_arg, sizeof(*t_cp)))	\
>> +			PANIC();					\
>> +		/* 2. copy the argument inside to prevent TOCTOU */	\
>> +		memcpy(t_cp, u_arg, sizeof(*t_cp));			\
>> +	} while (0)
>> +

This could be made into a static inline function, but then t_cp would 
have to be type void* and sizeof(*t_cp) won't work anymore and a third 
parameter to pass the sizeof would be needed, which would require the 
caller to pass it correctly. Hence, a macro seems "safer" to me here in 
this instance as it requires only 2 arguments. Agreed?

>> +#define ASSERT_INSIDE_ENCLAVE(u_arg, size)				\
>> +	do {								\
>> +		if (!is_inside_enclave(((void *)(u_arg)), size))	\
>> +			PANIC();					\
>> +	} while (0)

This macro could certainly be turned into a static inline void function 
if preferred.

Best,
Jo
