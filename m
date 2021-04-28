Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46467C433ED
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Apr 2021 03:07:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB0761408
	for <linux-sgx@archiver.kernel.org>; Wed, 28 Apr 2021 03:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhD1DIW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Apr 2021 23:08:22 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:37554 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230285AbhD1DIU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 27 Apr 2021 23:08:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=zhang.jia@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UX1VaFO_1619579254;
Received: from ali-6c96cfd98fb5.local(mailfrom:zhang.jia@linux.alibaba.com fp:SMTPD_---0UX1VaFO_1619579254)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 11:07:34 +0800
Subject: Re: SGX feature extensions patch.
To:     "Dr. Greg" <greg@enjellic.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
References: <20210426094538.GA8264@wind.enjellic.com>
From:   Jia Zhang <zhang.jia@linux.alibaba.com>
Message-ID: <7d8cc81d-79cb-469f-24dd-30905c7e6e0a@linux.alibaba.com>
Date:   Wed, 28 Apr 2021 11:07:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210426094538.GA8264@wind.enjellic.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Dr.Greg,

Thanks for your great job! I have a question about how do you work out
psw for
non-flc platforms?

The background is that we (inclavare containers project:
https://github.com/alibaba/inclavare-containers)
also attempt to resolve the conflict between non-flc platform and sgx
in-tree driver.
Our work is available at
https://github.com/alibaba/inclavare-containers/tree/master/hack/no-sgx-flc

In addition, I compare the different parts between us for non-flc
support part:
- Use different ioctl cmd to support init-token ioctl with token
supplied by caller
- Use different init-token ioctl structure (w/ vs w/o address parameter
in ELRANGE)

We did the testing on sgx1 machine and found it is required to modify
psw. See
https://github.com/alibaba/inclavare-containers/blob/master/hack/no-sgx-flc/Linux-SGX-PSW-2.13-Support-SGX1-machine-with-SGX-in-tree-driver.patch

So we are interested how do you avoid to modify PSW to work out.

Cheers,
Jia
On 2021/4/26 下午5:45, Dr. Greg wrote:
> Good morning, I hope the week is starting well for everyone.
>
> With the SGX driver having been mainlined in the 5.11 release we will
> be maintaining and releasing our out-of-tree SGX feature extension
> patch for each kernel release.
>
> The patches will be available using the following URL format:
>
> ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-MAJOR.MINOR.patch
>
> With the detached signature available via the following URL:
>
> ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-MAJOR.MINOR.patch.asc
>
> The 5.11 patch and signature can thus be retrieved via the following
> URL's:
>
> ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-5.11.patch
>
> ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-5.11.patch.asc
>
> I've included the public signing key that is being used for the
> signatures at the end of this e-mail.
>
> In addition to implementing cryptographic access control policies, the
> feature extension patch allows the mainline driver to work on
> platforms that do not have Flexible Launch Control.
>
> The changelog for the patch contains documentation for how to use the
> cryptographic access control policies, along with the rationale for
> enabling support for non-FLC platforms, which is basically the fact
> that with the mainline Linux driver there is very little hardware
> available to developers who would be interested in working with SGX on
> Linux.
>
> The driver extensions are unit tested on both FLC and non-FLC
> hardware.
>
> We would, of course, be interested in any productive suggestions,
> security issues or enhancement requests.  Depending on the trajectory
> of mainline development, we may add support for partial page
> initialization if that doesn't look like it is headed for mainline
> inclusion.
>
> Best wishes for a productive week.
>
> Dr. Greg
>
> -----BEGIN PGP PUBLIC KEY BLOCK-----
>
> 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
> unEH7sy5Alwk3lu03EE2iJzcAsQ4jq3xYSt0nw==
> =WFeh
> -----END PGP PUBLIC KEY BLOCK-----
>
> As always,
> Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
> Enjellic Systems Development, LLC     IOT platforms and edge devices.
> 4206 N. 19th Ave.
> Fargo, ND  58102
> PH: 701-281-1686                      EMAIL: greg@enjellic.com
> ------------------------------------------------------------------------------
> "Heaven goes by favor.  If it went by merit, you would stay out and your
>  dog would go in."
>                                 -- Mark Twain
