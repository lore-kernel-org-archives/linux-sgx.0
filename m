Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290E7BD
	for <linux-sgx@vger.kernel.org>; Mon, 11 Dec 2023 00:41:13 -0800 (PST)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-6da00040aafso2575539a34.1
        for <linux-sgx@vger.kernel.org>; Mon, 11 Dec 2023 00:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702284072; x=1702888872;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HNpK7gVVocd6D97UNc/uU33LSZEMZP8thvqp4QD621w=;
        b=Jnx/XSR6NzsOGT0fXMaAtcatgERvNdkoB3O/stX4Jf4EYRvfAxp6g79e1qRF1XCtEf
         s6yoFVc/MR4w32PRvYlb70P/cZ0d1SBtm9OmhtD9p9OvcWqj+DRkCFhSUl3FaXg4rOCS
         0F4PVgEplBf1IuQJBJDpvuLwYViQp18FYPPZlsM6iTb9pQo07ta4EmpllWkqXbA4Xv5t
         MM7tBmHCnE4AsTBbWwKSzaftLBPe8jvLNaZWU5XzGQAnDX9PlmdKNoYjrQzx2DobTlmh
         y3d3qL17BnSZHqxkmwakutpH5SRxCHkSk9j04pEmL7pad78j+MH5pL+H0NTnGZ1UomhD
         3MWg==
X-Gm-Message-State: AOJu0Ywo1s6N1jsiV/DAV9GcQtWrgLTtPV3DnvNFSa6XeD5a9/jZc751
	DKkiaK0K75sFHS518g6fjQjATCb/QlQ2elko4ghKFVQ/WvOq
X-Google-Smtp-Source: AGHT+IGfKrROzc73KF0ejaUWsIpnsUmLsLBlTMqcRYfFE/B2YIdyfJZ5i9qn/JPhnNqB+AehJiu4dzQCN/IdUWyYcy93lo6E05KY
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6830:4104:b0:6d9:e33a:e4e7 with SMTP id
 w4-20020a056830410400b006d9e33ae4e7mr4031696ott.1.1702284072435; Mon, 11 Dec
 2023 00:41:12 -0800 (PST)
Date: Mon, 11 Dec 2023 00:41:12 -0800
In-Reply-To: <000000000000ad704b05f8de7e19@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071c5ec060c37e5e1@google.com>
Subject: Re: [v5.15] WARNING in kvm_arch_vcpu_ioctl_run
From: syzbot <syzbot+412c9ae97b4338c5187e@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jarkko@kernel.org, jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, syzkaller-lts-bugs@googlegroups.com, 
	tglx@linutronix.de, usama.anjum@collabora.com, vkuznets@redhat.com, 
	wanpengli@tencent.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Level: **

This bug is marked as fixed by commit:
KVM: x86: Remove WARN sanity check on hypervisor timer vs. UNINITIALIZED vCPU

But I can't find it in the tested trees[1] for more than 90 days.
Is it a correct commit? Please update it by replying:

#syz fix: exact-commit-title

Until then the bug is still considered open and new crashes with
the same signature are ignored.

Kernel: Linux 5.15
Dashboard link: https://syzkaller.appspot.com/bug?extid=412c9ae97b4338c5187e

---
[1] I expect the commit to be present in:

1. linux-5.15.y branch of
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
