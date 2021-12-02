Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8997C433F5
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Dec 2021 20:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348847AbhLBUm3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Dec 2021 15:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243367AbhLBUm3 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 2 Dec 2021 15:42:29 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF8FC06174A
        for <linux-sgx@vger.kernel.org>; Thu,  2 Dec 2021 12:39:06 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id m192so1280489qke.2
        for <linux-sgx@vger.kernel.org>; Thu, 02 Dec 2021 12:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfpOB/YwxBkZmHMU1DG9r5qDFp0zinpAqA+jC5ucWk4=;
        b=LzS1sKk/TTReAFEWlKUApPCYo+W6v9VRQwvJi0oULSe22j8TmhbOThj9BS9hdaQ+6M
         gWnPk4ETvcOQT8RcTgyiseviofwFhJ4o/WgWI1prBz1JZtD7S35fRzyTAkoFT8VTciYu
         v8DhFQXUEmkynzpEzwWfYSuALGBNZqtT7fAeHuw0Ziclrq6PIuntDNAocvAsJs6EehZd
         HSQskYlmz26JvlX4QZdSE0d9KDr5BAHke8x/OPvIqK7yVbGmanxnPtdv2/J1s7VwA9qM
         T33CPBfMJyIERRMecJnf1oDyq7xTuX55tc0Du/1JJqd4a/Z+HzoJG+zoNiMlCUyqvFkd
         41ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfpOB/YwxBkZmHMU1DG9r5qDFp0zinpAqA+jC5ucWk4=;
        b=ae+UmtZoMVCHwItLYY74qjTRl/7Op4lFdz45sCn5pSSSonFvWjtMDjXhZNHxt0p490
         PCwzxvy2PZOyteiycq7e1cjp1w+tk133QEswMM1XkGvpcmPhbWrINRCFxUmIIsR+u66c
         8IfD1iCisyzs0zH5Aa4Q3OW33xh9BraS86RtHNuO95kCjRZHFdYRuTA7MH/Jp1UwHB3u
         vkPs88DAY340PMhlyREJAx+EPkAJmLKqVdimaz1mnO271eSe4gQG9GVaYpjg+mg7/+Ay
         +i+yOnPAgLMza2cJ3hqBpR6tdsU0w73M4jz/ZuED1wUmaQIDRlAImFC8WhaH8vR7psg8
         O5bw==
X-Gm-Message-State: AOAM530j0npgjqkHXdnQNy1jjTwAqh072mviTO9A3ZeMJNnuktg34GtS
        9I+PKtXgSegqiI7FtYJAXfzXRC8hUnWgYpdt+Q0Lmw==
X-Google-Smtp-Source: ABdhPJwjRjpZnsXo8YziSlyzXGi+3LwY0M2piBNCr8jHpLSss4W4bgiO5A16H4+If8K6pshum+1rZfhjBc5CGvoFV6o=
X-Received: by 2002:a37:f619:: with SMTP id y25mr14291485qkj.201.1638477545592;
 Thu, 02 Dec 2021 12:39:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638381245.git.reinette.chatre@intel.com> <94d8d631-5345-66c4-52a3-941e52500f84@intel.com>
In-Reply-To: <94d8d631-5345-66c4-52a3-941e52500f84@intel.com>
From:   Nathaniel McCallum <nathaniel@profian.com>
Date:   Thu, 2 Dec 2021 15:38:55 -0500
Message-ID: <CAHAy0tQr17mhpHskr4Mr+ooGyxjbSqy02Z2UA27U7=Ew6MW2Rg@mail.gmail.com>
Subject: Re: [PATCH 00/25] x86/sgx and selftests/sgx: Support SGX2
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@linutronix.de,
        bp@alien8.de, luto@kernel.org, mingo@redhat.com,
        linux-sgx@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        kai.huang@intel.com, cathy.zhang@intel.com, cedric.xing@intel.com,
        haitao.huang@intel.com, mark.shanahan@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 2, 2021 at 1:30 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 12/1/21 11:22 AM, Reinette Chatre wrote:
> > * Support modifying permissions of regular enclave pages belonging to an
> >   initialized enclave. New permissions are not allowed to exceed the
> >   originally vetted permissions. Modifying permissions is accomplished
> >   with a new ioctl SGX_IOC_PAGE_MODP.
>
> It's probably also worth noting that this effectively punts on the issue
> of how to allow enclaves to relax the permissions on pages, like taking
> a page from R=>RW, or R=>RX.  RX isn't allowed unless the page was
> *added* originally with RX or RWX.
>
> Since dynamically added pages start with initial RW permissions, they
> can *never* be RX or RWX since they did not start with execute
> permissions.  That's a limitation, of course, but it's one that can be
> dealt with separately from this set.
>
> Does that sound sane to everyone?

We (Enarx) need arbitrary permission modifications. But for now we can
just use this patch series and patch the original permissions to be
RWX on all new pages. I think that should be sufficient.
