Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF403C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 11:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6402164FE1
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Mar 2021 11:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhCJLrq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Mar 2021 06:47:46 -0500
Received: from out0-154.mail.aliyun.com ([140.205.0.154]:34650 "EHLO
        out0-154.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbhCJLrS (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 10 Mar 2021 06:47:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1615376836; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=qF6h6Aqqj5613OVgkmhwFm/OnbZiDOkwrkWlxUm5rtc=;
        b=Oe8aLgBy7Iy/i9WCLoJ/bxIoViofofp0UrJsfFVlHFRYKbc/fY69EpFkiumHy4B441HtjZS71xJdaPZfl5VyItqIfse/sOwM6TlkPJ3IWGTvkJewZeeAqRlcyzJjECbin9dEGXIeNBWEdw/atWdgjZ0Q+VK4o0V8sbS03hupM/0=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=qianyue.zj@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.JizUs3N_1615376834;
Received: from ali-6c96cfd98fb5.local(mailfrom:qianyue.zj@alibaba-inc.com fp:SMTPD_---.JizUs3N_1615376834)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 19:47:14 +0800
Subject: Re: SGX Linux-Compatible Hardware
To:     Dave Hansen <dave@sr71.net>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
References: <399c5f27-1387-55c5-e147-f7885bf86df5@sr71.net>
From:   "=?UTF-8?B?5Lm+6LaK?=" <qianyue.zj@alibaba-inc.com>
Message-ID: <50a49b71-175a-8d30-ab83-62bd8049982b@alibaba-inc.com>
Date:   Wed, 10 Mar 2021 19:47:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <399c5f27-1387-55c5-e147-f7885bf86df5@sr71.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

https://github.com/ayeks/SGX-hardware provides a nice tool to check the
sgx capability. It
reported 2 SGX2 platforms with FLC support.

Jia

On 2021/3/9 上午9:04, Dave Hansen wrote:
> As everyone probably knows, the upstream kernel SGX support refuses to
> run on some SGX hardware.  Linux requires that the Launch Control MSRs
> be writable, which is sometimes known as "Flexible Launch Control"
> support.  If those MSRs are not writable, Linux will ignore the presence
> of otherwise SGX-capable hardware.
>
> It can be somewhat challenging to find hardware which works.  For
> instance I've got a i7-8086K which has all of the processor support
> required for SGX, but the system firmware still opts to lock the Launch
> Control MSRs.
>
> I wanted to report that an Intel NUC7CJYH successfully runs enclaves on
> Linux out of the box.  The Intel hardware compatibility list[1] is a bit
> scary, so I've also included a link to the exact memory that I got.
> 16GB of RAM seems to work just fine despite what the Intel Ark pages on
> the CPU says[2].
>
> One little annoyance is that although it came with an A/C adapter, it
> didn't come with a power cord.  There's a link to one of those below too.
>
>> https://www.newegg.com/intel-boxnuc7cjyh/p/1VK-004K-001W5
>> https://www.newegg.com/g-skill-16gb-260-pin-ddr4-so-dimm/p/N82E16820232154?Item=N82E16820232154
>> https://www.newegg.com/startech-3-ft-black-standard-power-cord/p/N82E16812400031
> 1. https://compatibleproducts.intel.com/ProductDetails?EPMID=126135
> 2.
> https://ark.intel.com/content/www/us/en/ark/products/128992/intel-celeron-j4005-processor-4m-cache-up-to-2-70-ghz.html
