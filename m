Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC7AC2BABC
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 08:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51CDB2074B
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 08:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rh1NyRGG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgDGIsW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 04:48:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37024 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728043AbgDGIsQ (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Apr 2020 04:48:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id r24so2787809ljd.4
        for <linux-sgx@vger.kernel.org>; Tue, 07 Apr 2020 01:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fib4anZa5KIgclRP/O90WMwO+lXiy6RjtpZkH9dGsuY=;
        b=Rh1NyRGGnkURF8mYMKl/ZCVyfldt58i04Kz8NaGaIQF301gIkOSiI9Uv1omMLgNk5V
         Lanp4PsoRxmhvhfKHgvBHBbvoW3gEGhV0j+G4e0+0YOKZyqjuoqnU7bW6BU0JXzRW4sM
         m/sJ970rte7LN4qqpwQXmuv7nKQ8SMM1HbjLzM9lKhTfA7DWnt468IGgzZcl9JvEPZut
         F01nLW6zylOSjzJvcH+vD5ijl5Ov8NoRy8/0PbT5NRqkty/zTun8Oaj18hZEXvdN/u5N
         PlPzqPpYhTi3OllyI4OvBGiqFr2/7n0NYIINI+/0Zc2VCtK9oFKWuJK5jfvIuU1YDl96
         jxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fib4anZa5KIgclRP/O90WMwO+lXiy6RjtpZkH9dGsuY=;
        b=aZ/D20JenGnWeu5FOqL8RSnTngNKlyh9nVxCTAYWPp8S1ZJqXnfF6SaI9Kwn6A6xjU
         JFYkEjHbVf2q4MKh7xR+ujfyDhhurhhc09qD7lE6DyFvAJM1ErtrRdl4LTVmsJEwIt/8
         WjbX4jwLT+uDHGkU1iAx+brccRQrDqROk4MYT+/+LAwF/YalG5s82AuWKeaXMSByskSI
         8+fI3FkG8bclVpeU3c+QEq228fSum7MT1cEqWyyxPe93RDd6c4RdDQFOWuNvbzveY+9M
         Li/wd5W1LdwwNaOFY7CklicFRjPuQjNiqN9RYj0K9Ljtf/99irwZvwIvu/6AGYaK3zMS
         Gtsw==
X-Gm-Message-State: AGi0Puab3jFiOvpYO/+xmsA1vt2XSS9LnPdtQinsq7ZnOf1b8E5sI/f1
        wjkzVPZQ5R255x6MmHDllXk=
X-Google-Smtp-Source: APiQypLGSuQa3Mb124sv0JY+wgAQuWRJVb9q5btrMNR8KAVmfmrRVU5dDl+I4ZZEI2ioxEhO96q9/g==
X-Received: by 2002:a2e:91da:: with SMTP id u26mr1087324ljg.232.1586249292887;
        Tue, 07 Apr 2020 01:48:12 -0700 (PDT)
Received: from [192.168.1.38] (88-114-211-119.elisa-laajakaista.fi. [88.114.211.119])
        by smtp.gmail.com with ESMTPSA id a26sm11117249ljn.22.2020.04.07.01.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 01:48:12 -0700 (PDT)
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
From:   Topi Miettinen <toiwoton@gmail.com>
Message-ID: <4768f3fd-74fa-3581-5cda-8c09b4ddc3f2@gmail.com>
Date:   Tue, 7 Apr 2020 11:48:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200406212434.GA34134@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7.4.2020 0.24, Jarkko Sakkinen wrote:
> In my opinion udev defining the whole /dev as noexec has zero technical
> merits. It is same as they would say that "we don't trust our own
> database". There are no real security benefits as long as dev nodes are
> configured correctly.

The threat is not that the device nodes would have execute permissions, 
but that a malicious entity with write access to /dev would create a new 
executable and run it, or rather, trick another (perhaps more privileged 
or more vulnerable) entity to do so. The malicious entity does not need 
any capabilities and it can be constrained by any number of typical 
seccomp filters which just don't block such basic system calls as 
open(), write(), [f]chmod() and close(). It simply needs to have UID 0 
(possibly something else, like suitable GID could also be sufficient for 
some subdirectories) and write access to /dev (or its subdirectories) in 
its mount namespace.

My philosophy is that "trust" means confidence that an action will not 
be done even when there's no control over it. "Control" means that it's 
possible to make active decision on whether the action can or cannot be 
allowed to be done. Trust in security mindset is a weak thing, control 
is stronger, but the strongest case is when you don't need trust nor 
control: the action simply can't ever happen because it's impossible or 
always forbidden. This idea is shown in such famous principles as "least 
privilege", "need to know" or compartmentalization. If the additional 
privilege of exec is not needed, it should not exist.

-Topi
