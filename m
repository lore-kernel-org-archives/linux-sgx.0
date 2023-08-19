Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23615EE49AD
	for <linux-sgx@archiver.kernel.org>; Sat, 19 Aug 2023 08:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344828AbjHSIEz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 19 Aug 2023 04:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344729AbjHSIE1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 19 Aug 2023 04:04:27 -0400
Received: from icts-p-cavuit-4.kulnet.kuleuven.be (icts-p-cavuit-4.kulnet.kuleuven.be [134.58.240.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E879170E;
        Sat, 19 Aug 2023 01:04:25 -0700 (PDT)
X-KULeuven-Envelope-From: jo.vanbulck@cs.kuleuven.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: 9ECAC121.A9624
X-KULeuven-Information: Katholieke Universiteit Leuven
Received: from icts-p-ceifnet-smtps-1.kuleuven.be (icts-p-ceifnet-smtps.service.icts.svcd [IPv6:2a02:2c40:0:51:145:242:ac11:22])
        by icts-p-cavuit-4.kulnet.kuleuven.be (Postfix) with ESMTP id 9ECAC121;
        Sat, 19 Aug 2023 10:04:21 +0200 (CEST)
BCmilterd-Mark-Subject: no
BCmilterd-Errors: 
BCmilterd-Report: SA-HVU#DKIM_VALID_AU#0.00,SA-HVU#DKIM_VALID#0.00,SA-HVU#DKIM_SIGNED#0.00
X-CAV-Cluster: smtps
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.kuleuven.be;
        s=cav; t=1692432261;
        bh=dmdBsI8OfJdU+j8FAcFdEZAkzJYhysJmOSrH6xJROHk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=bCBBOAu4AJ9iZvl6sqBHGApPwCF6bgtJFLac+tK9K2a3SWLy9rSUpnGwxst6uXR8h
         w4drUTMChoELcN5/f2I7agXH2MxX139Ua9xYs32cRinWh2KuApB6KsUHuUcP4N4KQ1
         ZSv+Kn8pTcCvmvFAzR659N1eO5Y3PFHT/dPhClIA=
Received: from [192.168.44.147] (ptr-94-109-233-233.dyn.orange.be [94.109.233.233])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by icts-p-ceifnet-smtps-1.kuleuven.be (Postfix) with ESMTPSA id 52300D4EB32C2;
        Sat, 19 Aug 2023 10:04:20 +0200 (CEST)
Message-ID: <e4180cc8-804d-dadd-e087-619cf165bb64@cs.kuleuven.be>
Date:   Fri, 18 Aug 2023 18:11:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/5] selftests/sgx: Ensure expected enclave data buffer
 size and placement.
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
References: <20230724165832.15797-1-jo.vanbulck@cs.kuleuven.be>
 <20230724165832.15797-5-jo.vanbulck@cs.kuleuven.be>
 <CUE1R4HRQ599.1BX4CEIPSDWRW@seitikki>
 <a2732938-f3db-a0af-3d68-a18060f66e79@cs.kuleuven.be>
 <4022cb20af2759d0e71f72a1b4161b3e43181bca.camel@intel.com>
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From:   Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
In-Reply-To: <4022cb20af2759d0e71f72a1b4161b3e43181bca.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 18.08.23 06:07, Huang, Kai wrote:
> Could we use "used" attribute?
> 
> https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html
> 
> used
> 
> 	This attribute, attached to a variable with static storage, means that
> 	the variable must be emitted even if it appears that the variable is
> 	not referenced.
> 
> 	When applied to a static data member of a C++ class template, the
> 	attribute also means that the member is instantiated if the class
> 	itself is instantiated.

Thank you for pointing this out! I was not aware of this attribute, but 
it is indeed exactly what we need in this case and works as expected.

>>
>> 2. adding _attribute__((section(".data.encl_buffer"))) ensures that we
>> can control the expected location at the start of the .data section. I
>> think this is optional, as encl_buf always seems to be placed at the
>> start of .data in all my tests. But afaik this is not guaranteed as per
>> the C standard and such constraints on exact placement should better be
>> explicitly controlled in the linker script(?)
> 
> This looks sane.

Thanks, applying this in a separate commit as discussed.

Best,
Jo
